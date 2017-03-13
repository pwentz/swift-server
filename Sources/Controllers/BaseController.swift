import SocksCore
import Requests
import Responses

public class BaseController {
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
        var response: Response

        switch request.path {
        case "/logs":
          let logsController = LogsController(request)
          response = logsController.process(logs: logs)

        case "/cookie":
          response = Response(status: 200,
                              headers: ["Content-Type": "text/html",
                                        "Set-Cookie": "type=chocolate"],
                              body: "Eat")

        case "/eat_cookie":
          response = Response(status: 200,
                              headers: ["Content-Type": "text/html"],
                              body: "mmmm chocolate")

        default:
          logs.append("\(request.verb) \(request.path) HTTP/1.1")
          response = Response(status: 200,
                              headers: ["Content-Type": "text/html"],
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
