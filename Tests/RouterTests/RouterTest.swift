import XCTest
@testable import Router
import Responders
import Requests
import Responses
import FileIO
import Util

class MockResponder: Responder {
  public func getResponse(to request: HTTPRequest) -> HTTPResponse {
    return HTTPResponse(status: TwoHundred.Ok)
  }
}

class RouterTest: XCTestCase {

  func testItBindsTheSocket() throws {
    let port: UInt16 = 5000
    let mockSock = MockTCPSocket()
    let router = Router(socket: mockSock, threadQueue: MockOperationQueue(), port: port, responder: MockResponder())

    try router.listen()

    XCTAssert(mockSock.wasBindCalled)
  }

  func testItOpensTheSocketToListen() throws {
    let port: UInt16 = 5000
    let mockSock = MockTCPSocket()
    let router = Router(socket: mockSock, threadQueue: MockOperationQueue(), port: port, responder: MockResponder())

    try router.listen()

    XCTAssert(mockSock.wasBindCalled)
  }

  func testItAcceptsTheSocket() throws {
    let port: UInt16 = 5000
    let mockSock = MockTCPSocket()
    let router = Router(socket: mockSock, threadQueue: MockOperationQueue(), port: port, responder: MockResponder())

    try router.receive()

    XCTAssert(mockSock.wasAcceptCalled)
  }

  func testItReceivesData() throws {
    let port: UInt16 = 5000
    let mockSock = MockTCPSocket()
    let router = Router(socket: mockSock, threadQueue: MockOperationQueue(), port: port, responder: MockResponder())

    try router.receive()

    XCTAssert(mockSock.wasRecvCalled)
  }

  func testItRunsDispatchAsyncMethodIfDataIsNotEmpty() throws {
    let rawRequest = "GET /logs HTTP/1.1\r\n Host: localhost:5000\r\n Connection: Keep-Alive\r\n User-Agent: Apache-HttpClient/4.3.5 (java 1.5)\r\n Accept-Encoding: gzip,deflate"
    let port: UInt16 = 5000

    let mockSock = MockTCPSocket(rawRequest)
    let mockQueue = MockOperationQueue()
    let router = Router(socket: mockSock, threadQueue: mockQueue, port: port, responder: MockResponder())

    try router.receive()

    XCTAssert(mockQueue.wasAsyncMethodCalled)
  }

  func testItCallsSendOnSocketWhenDataPassed() throws {
    let rawRequest = "GET /logs HTTP/1.1"

    let mockSock = MockTCPSocket(rawRequest)
    let mockQueue = MockOperationQueue()
    let router = Router(socket: mockSock, threadQueue: mockQueue, port: 5000, responder: MockResponder())
    let response = HTTPResponse(status: TwoHundred.Ok)

    let dispatchCallback = router.getDispatchCallback(response, client: mockSock)

    router.dispatch(dispatchCallback)
    XCTAssert(mockSock.wasSendCalled)
  }

  func testItCallsCloseOnSocketWhenDataPassed() throws {
    let rawRequest = "GET /logs HTTP/1.1"

    let mockSock = MockTCPSocket(rawRequest)
    let mockQueue = MockOperationQueue()
    let router = Router(socket: mockSock, threadQueue: mockQueue, port: 5000, responder: MockResponder())
    let response = HTTPResponse(status: TwoHundred.Ok)

    let dispatchCallback = router.getDispatchCallback(response, client: mockSock)

    router.dispatch(dispatchCallback)
    XCTAssert(mockSock.wasCloseCalled)
  }

  func testItDoesNotCallDispatchAsyncIfDataIsEmpty() throws {
    let port: UInt16 = 5000

    let mockSock = MockTCPSocket()
    let mockQueue = MockOperationQueue()
    let router = Router(socket: mockSock, threadQueue: mockQueue, port: port, responder: MockResponder())

    try router.receive()

    XCTAssert(mockQueue.wasAsyncMethodCalled == false)
  }
}
