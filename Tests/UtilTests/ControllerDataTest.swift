import XCTest
@testable import Util

class ControllerDataTest: XCTestCase {
  func testItHasAGetter() {
    let contents: [String: Data] = ["file1": Data(bytes: "I'm a text file".toBytes)]
    let data = ResourceData(contents)

    XCTAssertEqual(data.get("file1"), "I'm a text file")
  }

  func testItCanMutateValues() {
    let contents: [String: Data] = ["file1": Data(bytes: "I'm a text file".toBytes)]
    let data = ResourceData(contents)

    data.update("file1", withVal: "I'm a modified text file")

    XCTAssertEqual(data.get("file1"), "I'm a modified text file")
  }

  func testMutationsPersistToReferences() {
    let contents: [String: Data] = ["file1": Data(bytes: "I'm a text file".toBytes)]
    let data = ResourceData(contents)

    let referenceToData: [ResourceData] = [data]

    data.update("file1", withVal: "I'm a modified text file")

    XCTAssertEqual(referenceToData.first!.get("file1"), "I'm a modified text file")
  }

  func testItCanFilterOutGivenFilenames() {
    let contents: [String: Data] = ["file1": Data(bytes: "I'm a text file".toBytes)]

    let data = ResourceData(contents)

    XCTAssertEqual(data.fileNames, ["file1"])
  }
}
