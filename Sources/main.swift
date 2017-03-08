import Foundation
import SocksCore

func getBase64(of input: String) -> String {
  let data = input.data(using: String.Encoding.utf8)
  return data!.base64EncodedString(options: Data.Base64EncodingOptions(rawValue: 0))
}

func separate(_ input: String, by separator: Character) -> [String] {
  return input.characters.split { $0 == separator }.map(String.init)
}

let baseEncodedAuth = getBase64(of: "admin:hunter2")

var logs: [String] = []

do {
  let address = InternetAddress.localhost(port: 5000)
  let socket = try TCPInternetSocket(address: address)

  try socket.bind()
  try socket.listen()

  print("Listening on \"\(address.hostname)\" (\(address.addressFamily)) \(address.port)")

  while true {
    let client = try socket.accept()

    let data = try client.recv()


    let parsedRequest = try separate(data.toString(), by: "\r\n")
    let parsedRequestMain = separate(parsedRequest[0], by: " ")
    let requestVerb = parsedRequestMain[0]
    var path = parsedRequestMain[1]

    var statusCode = "200 OK"

    let authHeader = parsedRequest.filter { $0.hasPrefix("Authorization: Basic") }

    var authCredentials = ""

    if path == "/logs" {
      if authHeader.count > 0 {
        let splitCredentials = separate(authHeader[authHeader.startIndex], by: " ")
        authCredentials = splitCredentials[splitCredentials.index(before: splitCredentials.endIndex)]

        if authCredentials == baseEncodedAuth {
          statusCode = "200 OK"
          path = "/log"
        }
      }
      else {
        statusCode = "401 Unauthorized"
      }
    }

    let responseHeaders = ["HTTP/1.1 \(statusCode)",
                           "WWW-Authenticate: Basic realm=\"simple\"",
                           "Content-Type: text/html; charset=iso-8859-1"]

    let rawResponseHeaders = responseHeaders.joined(separator: "\r\n")
    var response: [UInt8] = []

    let formattedResponseHeaders: [UInt8] = Array(rawResponseHeaders.utf8)

    if statusCode == "200 OK" {
      logs.append("\(requestVerb) \(path) HTTP/1.1\n")

      let formattedResponseBody: [UInt8] = Array(logs.joined(separator: "\r\n").utf8)

      response = formattedResponseHeaders + formattedResponseBody

      try client.send(data: response)
    }
    else {
      response = formattedResponseHeaders
      try client.send(data: response)
    }

    try client.close()

    print("Client: \(client.address), Request: \(try data.toString()), Response: \(try response.toString())\n\n")
  }
} catch {
  print("Error \(error)")
}
