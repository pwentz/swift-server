public enum ServerStartError: Error {
  case MissingPublicDirectoryArgument
  case InvalidPublicDirectoryGiven
  case MissingArgumentFor(flag: String)
}

extension ServerStartError: Equatable {
  public static func ==(lhs: ServerStartError, rhs: ServerStartError) -> Bool {
    switch (lhs, rhs) {
    case (.MissingPublicDirectoryArgument, .MissingPublicDirectoryArgument):
      return true
    case (.InvalidPublicDirectoryGiven, .InvalidPublicDirectoryGiven):
      return true

    case (.MissingArgumentFor(flag: let lFlag), .MissingArgumentFor(flag: let rFlag)):
      return lFlag == rFlag

    default:
      return false
    }
  }
}
