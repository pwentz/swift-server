public enum ServerStartError: Error {
  case MissingPublicDirectoryArgument
  case InvalidPublicDirectoryGiven
  case MissingArgumentFor(flag: String)
}

public enum BadRequestError: Error {
  case InvalidRequest(for: String)
}
