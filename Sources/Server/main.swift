import Foundation
import FileHelpers
import Router

let today = Date()
let calendar = Calendar.current

let hour = calendar.component(.hour, from: today)
let minutes = calendar.component(.minute, from: today)
let seconds = calendar.component(.second, from: today)

let formatter = DateFormatter()
formatter.dateFormat = "MM-dd-yyyy"

let fileName = "logs-\(hour):\(minutes):\(seconds)--" + formatter.string(from: today)
let contents = CommandLine.arguments
let fullDirPath = contents.first!.components(separatedBy: "/Users/").last!.components(separatedBy: "/.build").first! + "/Sources/Server/Debug"

FileWriter(at: fullDirPath, with: contents.joined(separator: "\r\n")).write(to: fileName)

if let directoryFlagIndex = contents.index(where: { $0 == "-d" }) {
  let pathIndex = contents.index(after: directoryFlagIndex)
  let directoryPath: String = contents[pathIndex]

  print("||||||", FileReader(at: directoryPath).readContents())
}

let router = Router()

try router.listen()
