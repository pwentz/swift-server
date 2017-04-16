import Errors

public class CommandLineReader {
  private let args: [String]

  public init(args: [String]) {
    self.args = args
  }

  public func join(_ separator: String) -> String {
    return args.joined(separator: separator)
  }

  public func publicDirectoryArgs() throws -> String? {
    return try getArgumentAfter(flag: "-d")
  }

  public func portArgs() throws -> UInt16? {
    return try getArgumentAfter(flag: "-p").flatMap { UInt16($0) }
  }

  private func getArgumentAfter(flag: String) throws -> String? {
    return try args.index(where: { $0.contains(flag) }).map { flagIndex throws -> String in
      guard flagIndex != args.count - 1 else {
        throw ServerStartError.MissingArgumentFor(flag: flag)
      }

      return args[args.index(after: flagIndex)]
    }
  }

}
