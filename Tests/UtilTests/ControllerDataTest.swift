import XCTest
@testable import Util

class ControllerDataTest: XCTestCase {
  func testItHasAGetter() {
    let contents: [String: [UInt8]] = ["file1": Array("I'm a text file".utf8)]
    let data = ControllerData(contents)

    XCTAssertEqual(data.get("file1"), "I'm a text file")
  }

  func testItCanMutateValues() {
    let contents: [String: [UInt8]] = ["file1": Array("I'm a text file".utf8)]
    let data = ControllerData(contents)

    data.update("file1", withVal: "I'm a modified text file")

    XCTAssertEqual(data.get("file1"), "I'm a modified text file")
  }

  func testMutationsPersistToReferences() {
    let contents: [String: [UInt8]] = ["file1": Array("I'm a text file".utf8)]
    let data = ControllerData(contents)

    let referenceToData: [ControllerData] = [data]

    data.update("file1", withVal: "I'm a modified text file")

    XCTAssertEqual(referenceToData.first!.get("file1"), "I'm a modified text file")
  }
}
