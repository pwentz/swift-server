import Foundation
import SocksCore
import Router
import Util
import Errors
import Shared
import FileIO

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

  let persistedData = ControllerData(contents, nonFiles: ["form", "logs", "cookie"])

  let router = Router(socket: socket, data: persistedData, threadQueue: DispatchQueue.global(qos: .userInteractive), port: port)

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
