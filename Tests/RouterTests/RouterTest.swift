import XCTest
@testable import Router
import Responses
import FileIO
import Util

class RouterTest: XCTestCase {

  func testItBindsTheSocket() throws {
    let port: UInt16 = 5000
    let fileContents = ["file1": Data(value: "I'm a text file")]
    let controllerData = ControllerData(fileContents)
    let mockSock = MockTCPSocket()
    let router = Router(socket: mockSock, data: controllerData, threadQueue: MockOperationQueue(), port: port)

    try router.listen()

    XCTAssert(mockSock.wasBindCalled)
  }

  func testItOpensTheSocketToListen() throws {
    let port: UInt16 = 5000
    let fileContents = ["file1": Data(value: "I'm a text file")]
    let controllerData = ControllerData(fileContents)
    let mockSock = MockTCPSocket()
    let router = Router(socket: mockSock, data: controllerData, threadQueue: MockOperationQueue(), port: port)

    try router.listen()

    XCTAssert(mockSock.wasBindCalled)
  }

  func testItAcceptsTheSocket() throws {
    let port: UInt16 = 5000
    let fileContents = ["file1": Data(value: "I'm a text file")]
    let controllerData = ControllerData(fileContents)
    let mockSock = MockTCPSocket()
    let router = Router(socket: mockSock, data: controllerData, threadQueue: MockOperationQueue(), port: port)

    try router.receive()

    XCTAssert(mockSock.wasAcceptCalled)
  }

  func testItReceivesData() throws {
    let port: UInt16 = 5000
    let fileContents = ["file1": Data(value: "I'm a text file")]
    let controllerData = ControllerData(fileContents)
    let mockSock = MockTCPSocket()
    let router = Router(socket: mockSock, data: controllerData, threadQueue: MockOperationQueue(), port: port)

    try router.receive()

    XCTAssert(mockSock.wasRecvCalled)
  }

  func testItRunsDispatchAsyncMethodIfDataIsNotEmpty() throws {
    let rawRequest = "GET /logs HTTP/1.1\r\n Host: localhost:5000\r\n Connection: Keep-Alive\r\n User-Agent: Apache-HttpClient/4.3.5 (java 1.5)\r\n Accept-Encoding: gzip,deflate"
    let port: UInt16 = 5000

    let fileContents = ["file1": Data(value: "I'm a text file")]
    let controllerData = ControllerData(fileContents)
    let mockSock = MockTCPSocket(rawRequest)
    let mockQueue = MockOperationQueue()
    let router = Router(socket: mockSock, data: controllerData, threadQueue: mockQueue, port: port)

    try router.receive()

    XCTAssert(mockQueue.wasAsyncMethodCalled)
  }

  func testItCallsSendOnSocketWhenDataPassed() throws {
    let rawRequest = "GET /logs HTTP/1.1\r\n Host: localhost:5000\r\n Connection: Keep-Alive\r\n User-Agent: Apache-HttpClient/4.3.5 (java 1.5)\r\n Accept-Encoding: gzip,deflate"

    let fileContents = ["file1": Data(value: "I'm a text file")]
    let controllerData = ControllerData(fileContents)
    let mockSock = MockTCPSocket(rawRequest)
    let mockQueue = MockOperationQueue()
    let router = Router(socket: mockSock, data: controllerData, threadQueue: mockQueue, port: 5000)
    let response = HTTPResponse(status: TwoHundred.Ok)

    let dispatchExpectation = expectation(description: "Router#dispatch calls async method with given callback")
    let dispatchCallback = router.getDispatchCallback(response, client: mockSock)

    router.dispatch() { _ throws in
      try dispatchCallback()

      XCTAssert(mockSock.wasSendCalled)
      XCTAssert(mockSock.wasCloseCalled)
      dispatchExpectation.fulfill()
    }

    waitForExpectations(timeout: 0) { error in
      if let error = error {
        XCTFail("ERROR: \(error)")
      }
    }
  }

  func testItDoesNotCallDispatchAsyncIfDataIsEmpty() throws {
    let port: UInt16 = 5000

    let fileContents = ["file1": Data(value: "I'm a text file")]
    let controllerData = ControllerData(fileContents)
    let mockSock = MockTCPSocket()
    let mockQueue = MockOperationQueue()
    let router = Router(socket: mockSock, data: controllerData, threadQueue: mockQueue, port: port)

    try router.receive()

    XCTAssert(mockQueue.wasAsyncMethodCalled == false)
  }
}
