public enum HTTPRequestMethod: String {
  case Get, Post, Put, Delete, Patch, Options, Head

  public init?(verb: String?) {
    guard let validVerb = verb else {
      return nil
    }

    self.init(rawValue: validVerb)
  }
}
