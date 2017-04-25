import Foundation
import SocksCore
import Router
import Config
import FileIO
import Routes
import Responders
import Responses
import Util

let reader = CommandLineReader(args: CommandLine.arguments)
var contents: [String: Data] = [:]
let dateHelper = DateHelper(today: Date(), calendar: Calendar.current, formatter: DateFormatter())

func onReceive(_ timestamp: String) -> (_ content: String) throws -> Void {
  let urlPath = URL(fileURLWithPath: logsPath + "/" + timestamp).appendingPathExtension("txt")

  return urlPath.write
}

do {
  let port = try reader.portArgs() ?? defaultPort

  let address = InternetAddress.localhost(port: port)
  let socket = try TCPInternetSocket(address: address)

  let publicDir = try reader.publicDirectoryArgs() ?? ""
  let fileNames = try DirectoryReader(FileManager.default).getFileNames(at: publicDir)

  for file in fileNames {
    contents["/\(file)"] = try Data(contentsOf: URL(fileURLWithPath: publicDir + "/" + file))
  }

  let persistedData = ResourceData(contents)

  persistedData.fileNames.forEach {
    routes[$0] = Route(allowedMethods: [.Get, .Patch])
  }

  let responder = Responder(routes: routes, data: persistedData)

  let router = Router(
    socket: socket,
    threadQueue: DispatchQueue.global(qos: .userInteractive),
    port: port,
    responder: responder,
    dateHelper: dateHelper
  )

  try router.listen(onReceive: onReceive)

  while true {
    try router.receive()
  }
} catch {
  let timestamp = dateHelper.formatTimestamp(prefix: "FAILURE")
  let write = onReceive(timestamp)
  try write("ERROR: \(error)")

  throw error
}
