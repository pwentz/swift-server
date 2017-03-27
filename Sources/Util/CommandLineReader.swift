import Foundation
import Errors

public class CommandLineReader {
  private let args: [String]

  public var joinedArgs: String {
    return args.joined(separator: "\r\n")
  }

  public init() {
    args = CommandLine.arguments
  }

  public func getArgumentAfter(flag: String) throws -> String? {
    return try args.index(where: { $0.contains(flag) }).map { flagIndex throws -> String in
      guard flagIndex != args.count - 1 else {
        throw ServerStartError.MissingArgumentFor(flag: flag)
      }

      return args[args.index(after: flagIndex)]
    }
  }

  public func publicDirectoryArgs() throws -> String? {
    return try getArgumentAfter(flag: "-d")
  }

  public func portArgs() throws -> UInt16? {
    if let formattedPort = try getArgumentAfter(flag: "-p") {
      return UInt16(formattedPort)
    } else {
      return nil
    }
  }

}
