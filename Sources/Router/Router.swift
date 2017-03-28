import SocksCore
import Requests
import Responses
import Controllers
import Util

public class Router {

  public init() {}

  public func listen(port: UInt16) throws {
    let address = InternetAddress.localhost(port: port)
    let socket = try TCPInternetSocket(address: address)

    try socket.bind()
    try socket.listen()

    print("Listening on \"\(address.hostname)\" (\(address.addressFamily)) \(address.port)")

    while true {
      let client = try socket.accept()
      let data = try client.recv()
      let request = try Request(for: data.toString())

      let response = try ControllerFactory.process(request)

      try client.send(data: response.formatted)

      let fileContents = "REQUEST: \(try data.toString())\r\n" +
                         "RESPONSE: \(response.toString())"

      try FileWriter(at: logsPath, with: fileContents)
                    .write(to: formatTimestamp(prefix: "SUCCESS"))

      print(fileContents)

      try client.close()
    }
  }

}
