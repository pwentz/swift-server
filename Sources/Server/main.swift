import Foundation
import Router

let today = Date()
let calendar = Calendar.current

let hour = calendar.component(.hour, from: today)
let minutes = calendar.component(.minute, from: today)
let seconds = calendar.component(.second, from: today)

let formatter = DateFormatter()
formatter.dateFormat = "MM-dd-yyyy"

let fileName = "logs-\(hour):\(minutes):\(seconds)--" + formatter.string(from: today)

let contents = CommandLine.arguments.joined(separator: "/n")

let DocumentDirURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
let fileURL = DocumentDirURL.appendingPathComponent("../8th-light/projects/swift/server/Sources/Server/Debug/\(fileName)").appendingPathExtension("txt")

print("FilePath: \(fileURL.path)")

do {
  try contents.write(to: fileURL, atomically: true, encoding: String.Encoding.utf8)
} catch let error as NSError {
  print("ERROR:", error)
}

let router = Router()

try router.listen()
