import XCTest
@testable import Router
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

  func testItAddsAnOperationToResponseQueueIfDataIsNotEmpty() throws {
    let rawRequest = "GET /logs HTTP/1.1\r\n Host: localhost:5000\r\n Connection: Keep-Alive\r\n User-Agent: Apache-HttpClient/4.3.5 (java 1.5)\r\n Accept-Encoding: gzip,deflate"
    let port: UInt16 = 5000

    let fileContents = ["file1": Data(value: "I'm a text file")]
    let controllerData = ControllerData(fileContents)
    let mockSock = MockTCPSocket(rawRequest)
    let mockQueue = MockOperationQueue()
    let router = Router(socket: mockSock, data: controllerData, threadQueue: mockQueue, port: port)

    try router.receive()

    XCTAssertEqual(mockQueue.operationCount, 1)
  }

  func testItDoesNotAddAnOperationIfDataIsEmpty() throws {
    let port: UInt16 = 5000

    let fileContents = ["file1": Data(value: "I'm a text file")]
    let controllerData = ControllerData(fileContents)
    let mockSock = MockTCPSocket()
    let mockQueue = MockOperationQueue()
    let router = Router(socket: mockSock, data: controllerData, threadQueue: mockQueue, port: port)

    try router.receive()

    XCTAssertEqual(mockQueue.operationCount, 0)
  }

  func testItTellsQueueToWaitIfOperationLimitIsHit() throws {
    let rawRequest = "GET /logs HTTP/1.1\r\n Host: localhost:5000\r\n Connection: Keep-Alive\r\n User-Agent: Apache-HttpClient/4.3.5 (java 1.5)\r\n Accept-Encoding: gzip,deflate"
    let port: UInt16 = 5000

    let fileContents = ["file1": Data(value: "I'm a text file")]
    let controllerData = ControllerData(fileContents)
    let mockSock = MockTCPSocket(rawRequest)
    let mockQueue = MockOperationQueue()

    mockQueue.maxConcurrentOperationCount = 1

    let router = Router(socket: mockSock, data: controllerData, threadQueue: mockQueue, port: port)

    try router.receive()

    XCTAssert(mockQueue.wasWaitMethodCalled)
  }

}
