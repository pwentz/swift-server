import Foundation
import Errors

public class CommandLineReader {
  public static func getArgumentAfter(flag: String) throws -> String? {
    let args = CommandLine.arguments

    return try args.index(where: { file in file.contains(flag) }).map{ flagIndex throws -> String in
      guard flagIndex != args.count - 1 else {
        throw ServerStartError.missingArgumentFor(flag: flag)
      }

      return args[args.index(after: flagIndex)]
    }
  }

  public static func getPublicDirectoryContents() throws -> [String: String] {
    let directoryPath = try getArgumentAfter(flag: "-d")
    return try FileReader(at: directoryPath ?? "").readContents()
  }

  public static func getPortArgument() throws -> UInt16? {
    if let formattedPort = try getArgumentAfter(flag: "-p") {
      return UInt16(formattedPort)
    }
    else { return nil }
  }
}
