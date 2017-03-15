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

let contents = CommandLine.arguments

let fullDirPath = contents.first!.components(separatedBy: "/Users/").last!.components(separatedBy: "/.build").first!

let DocumentDirURL = try! FileManager.default.url(for: .userDirectory, in: .allDomainsMask, appropriateFor: nil, create: true)
let logsFileUrl = DocumentDirURL.appendingPathComponent("\(fullDirPath)/Sources/Server/Debug/\(fileName)").appendingPathExtension("txt")

if let directoryFlagIndex = contents.index(where: { $0 == "-d" }) {
  let pathIndex = contents.index(after: directoryFlagIndex)
  let directoryPath: String = contents[pathIndex]
  let publicFileNames = try! FileManager.default.contentsOfDirectory(atPath: directoryPath)

  var publicFiles: [String: String] = [:]

  for file in publicFileNames {
    let relativeDirectoryPath = directoryPath.components(separatedBy: "/Users/").last!
    let publicFileUrl = DocumentDirURL.appendingPathComponent("\(relativeDirectoryPath)/\(file)")

    do {
      let fileContents = try String(contentsOf: publicFileUrl)

      publicFiles.updateValue(fileContents, forKey: file)

    } catch let fileError as NSError {
      print("ERROR: ", fileError)
    }
  }

  print("|||||||||||||||", publicFiles)
}

do {
  try contents.first!.write(to: logsFileUrl, atomically: true, encoding: String.Encoding.utf8)
} catch let error as NSError {
  print("ERROR:", error)
}

let router = Router()

try router.listen()
