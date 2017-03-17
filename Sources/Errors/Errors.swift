public enum ServerStartError: Error {
  case missingPublicDirectoryArgument
  case missingDirectoryFlagArgument
  case invalidPublicDirectoryGiven
}
