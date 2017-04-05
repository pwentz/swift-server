import XCTest
@testable import Router
import Responses

class MockTCPSocket: Socket {
  var wasSendCalled: Bool = false
  var wasCloseCalled: Bool = false

  func send(data: [UInt8]) throws {
    wasSendCalled = true
  }

  func close() throws {
    wasCloseCalled = true
  }
}


class RespondOperationTest: XCTestCase {
  func itDoesNotSendOnInit() {
    let response = HTTPResponse(status: TwoHundred.Ok)
    let mockSocket = MockTCPSocket()

    let _ = RespondOperation(response: response, client: mockSocket)

    XCTAssert(mockSocket.wasSendCalled == false)
  }

  func itDoesNotCallCloseOnInit() {
    let response = HTTPResponse(status: TwoHundred.Ok)
    let mockSocket = MockTCPSocket()

    let _ = RespondOperation(response: response, client: mockSocket)

    XCTAssert(mockSocket.wasCloseCalled == false)
  }

  func itCallsSendOnSocketOnStart() {
    let response = HTTPResponse(status: TwoHundred.Ok)
    let mockSocket = MockTCPSocket()

    let operation = RespondOperation(response: response, client: mockSocket)

    operation.start()

    XCTAssert(mockSocket.wasSendCalled)
  }

  func itCallsCloseOnSocketOnStart() {
    let response = HTTPResponse(status: TwoHundred.Ok)
    let mockSocket = MockTCPSocket()

    let operation = RespondOperation(response: response, client: mockSocket)

    operation.start()

    XCTAssert(mockSocket.wasCloseCalled)
  }
}
