import Foundation
import Router
import Util
import Errors

let args = CommandLine.arguments

do {
  let defaultPort: UInt16 = 5000
  let givenPort = try CommandLineReader.getPortArgument()

  try Router().listen(port: givenPort ?? defaultPort)
}
catch {
  let fileName = formatTimestamp(prefix: "FAILURE")
  let joinedArgs = args.joined(separator: "\r\n")
  try FileWriter(at: logsPath, with: "ERROR: \(error)\r\nARGS: \(joinedArgs)").write(to: fileName)
  print(" ‼️  :", error)
}
