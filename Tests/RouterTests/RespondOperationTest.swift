import XCTest
@testable import Router
import Responses

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
