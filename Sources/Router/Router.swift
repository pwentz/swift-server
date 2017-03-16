import SocksCore
import Requests
import Responses
import Controllers

public class Router {
  public var logs: [String]
  public let directoryContents: [String: String]

  public init(_ directoryContents: [String: String]) {
    self.logs = []
    self.directoryContents = directoryContents
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
          response = FormattedResponse(status: 200,
                                       headers: ["Content-Type": "text/html"],
                                       body: "<a href=\"/file1\">file1</a><br><a href=\"/image.gif\">image.gif</a>")

        case "/file1":
          response = FormattedResponse(status: 200,
                                       headers: ["Content-Type": "text/html"],
                                       body: "file1 contents")

        case "/image.gif":
          let baseEncodedImage = directoryContents["image.gif"]!
          response = FormattedResponse(status: 200,
                                       headers: ["Content-Type": "text/html"],
                                       body: "<img src=\"data:image/gif;base64,\(baseEncodedImage)\"/>")

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
