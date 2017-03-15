import SocksCore
import Requests
import Responses
import Controllers

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
      while true {
        let client = try socket.accept()
        let data = try client.recv()
        let request = try Request(for: data.toString())
        var response: FormattedResponse

        switch request.path {
        case "/logs":
          let combinedLogs = logs.reduce("", { $0 + ($1 + "\n") }) +
                             "\(request.verb) \(request.path) HTTP/1.1"

          response = LogsController.process(request)
          response.body = Array(("\n\n" + combinedLogs).utf8)

        case let path where path.contains("cookie"):
          response = CookieController.process(request)

        case "/":
          logs.append("\(request.verb) \(request.path) HTTP/1.1")

          response = FormattedResponse(status: 200,
                                       headers: ["Content-Type": "text/html"],
                                       body: "<a href=\"/public/file1\">file1</a>")

        default:
          logs.append("\(request.verb) \(request.path) HTTP/1.1")
          response = FormattedResponse(status: 200,
                                       headers: ["Content-Type": "text/html", "Content-Location": ""],
                                       body: "")
        }

        try client.send(data: response.formatted)

        print("Client: \(client.address), Request: \(try data.toString()), Response \(try response.formatted.toString())\n\n")

        try client.close()
      }
    } catch {
      print("Error \(error)")
    }
  }
}
