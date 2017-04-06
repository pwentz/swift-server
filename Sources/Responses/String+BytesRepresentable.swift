extension String: BytesRepresentable {
  public var toBytes: [UInt8] {
    return Array(self.utf8)
  }
}
