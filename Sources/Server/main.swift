import Foundation
import Router
import Util
import Errors

let reader = CommandLineReader()

do {
  let defaultPort: UInt16 = 5000
  let givenPort = try reader.getPortArgument()

  try Router().listen(port: givenPort ?? defaultPort)
} catch {
  let fileName = formatTimestamp(prefix: "FAILURE")
  try FileWriter(at: logsPath, with: "ERROR: \(error)\r\nARGS: \(reader.joinedArgs)")
                .write(to: fileName)

  print(" ‼️  :", error)
}
