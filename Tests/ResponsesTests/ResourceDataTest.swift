import XCTest
@testable import Responses
import Util

class ControllerDataTest: XCTestCase {
  let contents = ["file1": "I'm a text file"]
  func testItHasAGetter() {
    let data = ResourceData(contents)

    XCTAssertEqual(data["file1"]!.toBytes, "I'm a text file".toBytes)
  }

  func testItCanMutateValues() {
    let data = ResourceData(contents)

    data.update("file1", withVal: "I'm a modified text file")

    XCTAssertEqual(data["file1"]!.toBytes, "I'm a modified text file".toBytes)
  }

  func testMutationsPersistToReferences() {
    let data = ResourceData(contents)

    let referenceToData = data

    data.update("file1", withVal: "I'm a modified text file")

    XCTAssertEqual(referenceToData["file1"]!.toBytes, "I'm a modified text file".toBytes)
  }

  func testItDoesNotUpdateWhenPassedNil() {
    let data = ResourceData(contents)

    data.update("file1", withVal: nil)

    XCTAssertEqual(data["file1"]!.toBytes, "I'm a text file".toBytes)
  }

  func testItRemovesValue() {
    let data = ResourceData(contents)

    data.remove(at: "file1")

    XCTAssertNil(data["file1"])
  }
}
