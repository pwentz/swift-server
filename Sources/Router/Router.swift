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

  public func listen() throws {
    let address = InternetAddress.localhost(port: 5000)
    let socket = try TCPInternetSocket(address: address)

    try socket.bind()
    try socket.listen()

    print("Listening on \"\(address.hostname)\" (\(address.addressFamily)) \(address.port)")

    do {
      let publicDirectoryContents = try getPublicDirectoryContents(flag: "-d")

      while true {
        let client = try socket.accept()
        let data = try client.recv()
        let request = try Request(for: data.toString())
        var response: FormattedResponse

        logs.append("\(request.verb) \(request.path) HTTP/1.1")

        switch request.path {
        case "/logs":
          let combinedLogs = logs.reduce("", { $0 + ($1 + "\n") }) +
                             "\(request.verb) \(request.path) HTTP/1.1"

          response = LogsController.process(request)
          response.body += combinedLogs

        case let path where path.contains("cookie"):
          response = CookieController.process(request)

        case "/":
          response = RootController.process(request, contents: publicDirectoryContents)

        case let path where publicDirectoryContents.keys.contains { file in path == "/\(file)" }:
          response = ResourcesController.process(request, contents: publicDirectoryContents)

        case "/foobar":
          let emptyHeaders: [String: String] = [:]
          response = FormattedResponse(status: 404,
                                       headers: emptyHeaders,
                                       body: "")

        case "/coffee":
          let emptyHeaders: [String: String] = [:]
          response = FormattedResponse(status: 418,
                                       headers: emptyHeaders,
                                       body: "I'm a teapot")

        default:
          response = FormattedResponse(status: 200,
                                       headers: ["Content-Type": "text/html", "Content-Location": ""],
                                       body: "")
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
