import Router

class MockTCPSocket: Socket {
  var wasBindCalled: Bool = false
  var wasListenCalled: Bool = false
  var wasAcceptCalled: Bool = false
  var wasRecvCalled: Bool = false
  var wasSendCalled: Bool = false
  var wasCloseCalled: Bool = false

  let rawRequest: String?

  init(_ rawRequest: String? = nil) {
    self.rawRequest = rawRequest
  }

  func listen() {
    wasListenCalled = true
  }

  func recv() throws -> [UInt8] {
    wasRecvCalled = true
    return rawRequest.map { Array($0.utf8) } ?? []
  }

  func bind() throws {
    wasBindCalled = true
  }

  func acceptSocket() throws -> Socket {
    wasAcceptCalled = true
    return self
  }

  func send(data: [UInt8]) throws {
    wasSendCalled = true
  }

  func close() throws {
    wasCloseCalled = true
  }
}
