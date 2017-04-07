public protocol Socket {
  func bind() throws

  func listen() throws

  func acceptSocket() throws -> Socket

  func send(data: [UInt8]) throws

  func recv() throws -> [UInt8]

  func close() throws
}
