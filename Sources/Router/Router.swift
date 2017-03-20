import SocksCore
import Requests
import Responses
import Controllers
import Util

public class Router {
  public var logs: [String]

  public init() {
    self.logs = []
  }

  public func listen(port: UInt16) throws {
    let address = InternetAddress.localhost(port: port)
    let socket = try TCPInternetSocket(address: address)

    try socket.bind()
    try socket.listen()

    print("Listening on \"\(address.hostname)\" (\(address.addressFamily)) \(address.port)")

    do {
      let publicDirectoryContents = try CommandLineReader().getPublicDirectoryContents()

      while true {
        let client = try socket.accept()
        let data = try client.recv()
        let request = try Request(for: data.toString())
        var response: Response

        switch request.path {
        case "/logs":
          response = LogsController.process(request, logs: logs)

        case let path where path.contains("cookie"):
          response = CookieController.process(request)

        case "/":
          response = RootController.process(request, contents: publicDirectoryContents)

        case let path where publicDirectoryContents.keys.contains { file in path == "/\(file)" }:
          response = ResourcesController.process(request, contents: publicDirectoryContents)

        case "/foobar":
          let emptyHeaders: [String: String] = [:]
          response = Response(status: 404,
                              headers: emptyHeaders,
                              body: "")

        case "/coffee":
          let emptyHeaders: [String: String] = [:]
          response = Response(status: 418,
                              headers: emptyHeaders,
                              body: "I'm a teapot")

        default:
          response = Response(status: 200,
                              headers: ["Content-Type": "text/html"],
                              body: "")

          logs.append("\(request.verb) \(request.path) HTTP/1.1")
        }

        try client.send(data: response.formatted)

        let fileContents = "REQUEST: \(try data.toString())\r\nRESPONSE: \(try response.formatted.toString())"

        try FileWriter(at: logsPath, with: fileContents).write(to: formatTimestamp(prefix: "SUCCESS"))

        print(fileContents)

        try client.close()
      }
    }
    catch { throw error }
  }
}
