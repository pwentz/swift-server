import SocksCore

extension TCPInternetSocket: Socket {

  public func recv() throws -> [UInt8] {
    return try self.recv(maxBytes: 65_507)
  }

  public func listen() throws {
    return try self.listen(queueLimit: 4096)
  }

  public func acceptSocket() throws -> Socket {
    return try self.accept()
  }

}
