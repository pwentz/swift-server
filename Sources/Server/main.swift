import Foundation
import Router
import Util

do {
  try Router().listen()
}
catch {
  let fileName = formatTimestamp(prefix: "FAIL")
  let joinedArgs = CommandLine.arguments.joined(separator: "\r\n")
  try FileWriter(at: logsPath, with: "ERROR: \(error)\r\nARGS: \(joinedArgs)").write(to: fileName)
  print(" ‼️  :", error)
}
