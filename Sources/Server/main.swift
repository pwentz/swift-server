import Router
import Util
import Errors
import Shared

let reader = CommandLineReader()

do {
  let defaultPort: UInt16 = 5000
  let givenPort = try reader.portArgs()

  try Router().listen(port: givenPort ?? defaultPort)
} catch {
  let fileName = formatTimestamp(prefix: "FAILURE")
  try FileWriter(at: logsPath, with: "ERROR: \(error)\r\nARGS: \(reader.joinedArgs)")
                .write(to: fileName)

  print(" ‼️  :", error)
  throw error
}
