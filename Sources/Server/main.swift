import Foundation
import FileHelpers
import Router
import Util

let dateHelper = DateHelper()
let currentTime = dateHelper.time(separator: ":")
let today = dateHelper.date(separator: "-")

let fileName = "logs-\(currentTime)--\(today)"

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
