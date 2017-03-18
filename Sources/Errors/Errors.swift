public enum ServerStartError: Error {
  case missingPublicDirectoryArgument
  case invalidPublicDirectoryGiven
  case missingArgumentFor(flag: String)
}
