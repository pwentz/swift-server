import XCTest
import Responses
@testable import Util

class ControllerDataTest: XCTestCase {
  func testItHasAGetter() {
    let contents: [String: BytesRepresentable] = ["file1": "I'm a text file"]
    let data = ResourceData(contents)

    XCTAssertEqual(data["file1"]!.toBytes, "I'm a text file".toBytes)
  }

  func testItCanMutateValues() {
    let contents: [String: BytesRepresentable] = ["file1": "I'm a text file"]
    let data = ResourceData(contents)

    data.update("file1", withVal: "I'm a modified text file")

    XCTAssertEqual(data["file1"]!.toBytes, "I'm a modified text file".toBytes)
  }

  func testMutationsPersistToReferences() {
    let contents: [String: BytesRepresentable] = ["file1": "I'm a text file"]
    let data = ResourceData(contents)

    let referenceToData: [ResourceData] = [data]

    data.update("file1", withVal: "I'm a modified text file")

    XCTAssertEqual(referenceToData.first!["file1"]!.toBytes, "I'm a modified text file".toBytes)
  }
}
