public protocol FileIO {
  func contentsOfDirectory(atPath path: String) throws -> [String]
}
