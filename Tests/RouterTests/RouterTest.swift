import XCTest
@testable import Router
import Responders
import Requests
import Responses
import FileIO
import Util

class MockResponder: Respondable {
  public func response(to request: HTTPRequest) -> HTTPResponse {
    return HTTPResponse(status: TwoHundred.Ok)
  }
}

class MockCaller {
  var writtenContent: String? = nil
  var timestamp: String? = nil

  func onReceive(_ content: String) throws {
    self.writtenContent = content
  }

  func listenCallback(_ timestamp: String) -> (_ content: String) throws -> Void {
    self.timestamp = timestamp
    return onReceive
  }

}

class RouterTest: XCTestCase {
  let rawRequest = "GET /logs HTTP/1.1\r\n\r\n"
  let port: UInt16 = 5000
  let dateHelper = DateHelper(
    today: Date(),
    calendar: MockCalendar(hour: 2, minute: 45, second: 30),
    formatter: MockFormatter(month: "04", day: "15", year: "2017")
  )

  func testItCallsOnSendCallbackWithTimestamp() throws {
    let mockSock = MockTCPSocket(rawRequest)
    let mockQueue = MockOperationQueue()
    let router = Router(socket: mockSock, threadQueue: mockQueue, port: port, responder: MockResponder(), dateHelper: dateHelper)

    let mockCaller = MockCaller()
    let listenCallback = mockCaller.listenCallback

    try router.listen(onReceive: listenCallback)
    try router.receive()

    XCTAssertEqual(mockCaller.timestamp, "SUCCESS-2:45:30--04-15-2017")
  }

  func testItCallsOnSendNestedCallbackWithResponse() throws {
    let mockSock = MockTCPSocket(rawRequest)
    let mockQueue = MockOperationQueue()
    let router = Router(socket: mockSock, threadQueue: mockQueue, port: port, responder: MockResponder(), dateHelper: dateHelper)

    let mockCaller = MockCaller()
    let listenCallback = mockCaller.listenCallback

    try router.listen(onReceive: listenCallback)
    try router.receive()

    let expectedContents = "REQUEST: GET /logs HTTP/1.1\r\n\r\n\r\nRESPONSE: HTTP/1.1 200 OK\r\n\r\n"

    XCTAssertEqual(mockCaller.writtenContent, expectedContents)
  }

  func testItBindsTheSocket() throws {
    let mockSock = MockTCPSocket()
    let router = Router(socket: mockSock, threadQueue: MockOperationQueue(), port: port, responder: MockResponder(), dateHelper: dateHelper)

    try router.listen(onReceive: MockCaller().listenCallback)

    XCTAssert(mockSock.wasBindCalled)
  }

  func testItOpensTheSocketToListen() throws {
    let mockSock = MockTCPSocket()
    let router = Router(socket: mockSock, threadQueue: MockOperationQueue(), port: port, responder: MockResponder(), dateHelper: dateHelper)

    try router.listen(onReceive: MockCaller().listenCallback)

    XCTAssert(mockSock.wasListenCalled)
  }

  func testItAcceptsTheSocket() throws {
    let mockSock = MockTCPSocket()
    let router = Router(socket: mockSock, threadQueue: MockOperationQueue(), port: port, responder: MockResponder(), dateHelper: dateHelper)

    try router.receive()

    XCTAssert(mockSock.wasAcceptCalled)
  }

  func testItReceivesData() throws {
    let mockSock = MockTCPSocket()
    let router = Router(socket: mockSock, threadQueue: MockOperationQueue(), port: port, responder: MockResponder(), dateHelper: dateHelper)

    try router.receive()

    XCTAssert(mockSock.wasRecvCalled)
  }

  func testItRunsDispatchAsyncMethodIfDataIsNotEmpty() throws {
    let mockSock = MockTCPSocket(rawRequest)
    let mockQueue = MockOperationQueue()
    let router = Router(socket: mockSock, threadQueue: mockQueue, port: port, responder: MockResponder(), dateHelper: dateHelper)

    try router.receive()

    XCTAssert(mockQueue.wasAsyncMethodCalled)
  }

  func testItCallsSendOnSocketWhenDataPassed() throws {
    let mockSock = MockTCPSocket(rawRequest)
    let mockQueue = MockOperationQueue()
    let router = Router(socket: mockSock, threadQueue: mockQueue, port: port, responder: MockResponder(), dateHelper: dateHelper)
    let response = HTTPResponse(status: TwoHundred.Ok)

    let dispatchCallback = router.getDispatchCallback(response, client: mockSock)

    router.dispatch(dispatchCallback)
    XCTAssert(mockSock.wasSendCalled)
  }

  func testItCallsCloseOnSocketWhenDataPassed() throws {
    let mockSock = MockTCPSocket(rawRequest)
    let mockQueue = MockOperationQueue()
    let router = Router(socket: mockSock, threadQueue: mockQueue, port: port, responder: MockResponder(), dateHelper: dateHelper)
    let response = HTTPResponse(status: TwoHundred.Ok)

    let dispatchCallback = router.getDispatchCallback(response, client: mockSock)

    router.dispatch(dispatchCallback)
    XCTAssert(mockSock.wasCloseCalled)
  }

  func testItDoesNotCallDispatchAsyncIfDataIsEmpty() throws {
    let mockSock = MockTCPSocket()
    let mockQueue = MockOperationQueue()
    let router = Router(socket: mockSock, threadQueue: mockQueue, port: port, responder: MockResponder(), dateHelper: dateHelper)

    try router.receive()

    XCTAssert(mockQueue.wasAsyncMethodCalled == false)
  }

  func testItSendsA400RequestIfInvalidRequest() throws {
    let invalidRequestLine = "GET/someRouteHTTP/1.1"
    let mockSock = MockTCPSocket(invalidRequestLine)
    let mockQueue = MockOperationQueue()
    let router = Router(socket: mockSock, threadQueue: mockQueue, port: port, responder: MockResponder(), dateHelper: dateHelper)

    try router.receive()

    XCTAssertEqual(mockSock.sentResponseCode!, "400 Bad Request")
  }

}
