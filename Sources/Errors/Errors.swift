public enum ServerStartError: Error {
  case MissingPublicDirectoryArgument
  case InvalidPublicDirectoryGiven
  case MissingArgumentFor(flag: String)
}
