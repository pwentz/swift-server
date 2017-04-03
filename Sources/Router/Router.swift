import SocksCore
import Requests
import Responses
import Controllers
import Util
import Shared

public class Router {

  public init() {}

  public func listen(port: UInt16) throws {
    let address = InternetAddress.localhost(port: port)
    let socket = try TCPInternetSocket(address: address)

    try socket.bind()
    try socket.listen()

    let publicDir = try CommandLineReader().publicDirectoryArgs()
    let contents = try FileReader(at: publicDir ?? "").read()

    let persistedData = ControllerData(contents)

    persistedData.addNew(key: "form", value: "")
    persistedData.addNew(key: "logs", value: "")
    persistedData.addNew(key: "cookie", value: "")

    print("Listening on \"\(address.hostname)\" (\(address.addressFamily)) \(address.port)")

    while true {
      let client = try socket.accept()
      let data = try client.recv()
      let request = try HTTPRequest(for: data.toString())

      let controller = ControllerFactory.getController(request, with: persistedData)

      let response = controller.process(request)

      try client.send(data: response.formatted)

      let fileContents = "REQUEST: \(try data.toString())\r\n" +
                         "RESPONSE: \(String(response: response))"

      try FileWriter(at: logsPath, with: fileContents)
                    .write(to: formatTimestamp(prefix: "SUCCESS"))

      print(fileContents)

      try client.close()
    }
  }

}
