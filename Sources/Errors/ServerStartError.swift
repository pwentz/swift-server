public enum ServerStartError: Error {
  case InvalidPublicDirectoryGiven
  case MissingArgumentFor(flag: String)
}
