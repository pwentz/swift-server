import Foundation
import Router
import Util
import Errors
import Shared
import FileIO

let reader = CommandLineReader()

do {
  let defaultPort: UInt16 = 5000
  let givenPort = try reader.portArgs()

  try Router().listen(port: givenPort ?? defaultPort)
} catch {
  let fileName = formatTimestamp(prefix: "FAILURE")
  let urlPath = URL(fileURLWithPath: logsPath + fileName).appendingPathExtension("txt")
  try FileWriter<URL>(at: urlPath, with: "ERROR: \(error)\r\nARGS: \(reader.joinedArgs)")
                     .write()

  print(" ‼️  :", error)
  throw error
}
