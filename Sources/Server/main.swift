import Foundation
import SocksCore
import Router
import Util
import Config
import FileIO
import Routes
import Responders

let defaultPort: UInt16 = 5000
let reader = CommandLineReader(args: CommandLine.arguments)
var contents: [String: Data] = [:]

do {
  let port = try reader.portArgs() ?? defaultPort

  let address = InternetAddress.localhost(port: port)
  let socket = try TCPInternetSocket(address: address)

  let publicDir = try reader.publicDirectoryArgs() ?? ""
  let fileNames = try DirectoryReader(FileManager.default).getFileNames(at: publicDir)

  for file in fileNames {
    contents[file] = try Data(contentsOf: URL(fileURLWithPath: publicDir + "/" + file))
  }

  let persistedData = ControllerData(contents)

  persistedData.fileNames.forEach {
    routes["/\($0)"] = Route(allowedMethods: [.Get, .Patch])
  }

  let responder = RouteResponder(routes: routes, data: persistedData)

  let router = Router(socket: socket, threadQueue: DispatchQueue.global(qos: .userInteractive), port: port, responder: responder)

  try router.listen()

  while true {
    try router.receive()
  }
} catch {
  let fileName = DateHelper(today: Date(), calendar: Calendar.current, formatter: DateFormatter()).formatTimestamp(prefix: "FAILURE")
  let urlPath = URL(fileURLWithPath: logsPath + "/" + fileName).appendingPathExtension("txt")
  try urlPath.write(writableContent: "ERROR: \(error)\r\nARGS: \(reader.join("\r\n"))")

  throw error
}
