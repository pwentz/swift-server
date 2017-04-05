import SocksCore
import Foundation
import Requests
import Responses
import Controllers
import Util
import Shared
import FileIO

public class Router {

  public init() {}

  public func listen(port: UInt16) throws {
    let fileManager = FileManager.default
    let address = InternetAddress.localhost(port: port)
    let socket = try TCPInternetSocket(address: address)

    try socket.bind()
    try socket.listen()

    let publicDir = try CommandLineReader().publicDirectoryArgs() ?? ""
    let fileNames = try FileReader(fileManager).getFileNames(at: publicDir)
    var contents: [String: Data] = [:]

    for file in fileNames {
      contents[file] = try Data(contentsOf: URL(fileURLWithPath: publicDir + "/" + file))
    }

    let persistedData = ControllerData(contents)

    persistedData.addNew(key: "form", value: "")
    persistedData.addNew(key: "logs", value: "")
    persistedData.addNew(key: "cookie", value: "")

    print("Listening on \"\(address.hostname)\" (\(address.addressFamily)) \(address.port)")

    let opQueue: OperationQueue = OperationQueue()

    while true {
      let client = try socket.accept()
      let data = try client.recv()

      if !data.isEmpty {
        let request = try HTTPRequest(for: data.toString())
        let newOperation = RespondOperation(request: request, persistedData: persistedData, client: client)
        opQueue.addOperation(newOperation)
      }

      if opQueue.operationCount == opQueue.maxConcurrentOperationCount {
        opQueue.waitUntilAllOperationsAreFinished()
      }
    }
  }
}
