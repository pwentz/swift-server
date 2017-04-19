import XCTest
@testable import Util

class ControllerDataTest: XCTestCase {
  func testItHasAGetter() {
    let contents: [String: Data] = ["file1": ("I'm a text file".toData)]
    let data = ResourceData(contents)

    XCTAssertEqual(data["file1"], "I'm a text file".toData)
  }

  func testItCanMutateValues() {
    let contents: [String: Data] = ["file1": "I'm a text file".toData]
    let data = ResourceData(contents)

    data.update("file1", withVal: "I'm a modified text file")

    XCTAssertEqual(data["file1"], "I'm a modified text file".toData)
  }

  func testMutationsPersistToReferences() {
    let contents: [String: Data] = ["file1": "I'm a text file".toData]
    let data = ResourceData(contents)

    let referenceToData: [ResourceData] = [data]

    data.update("file1", withVal: "I'm a modified text file")

    XCTAssertEqual(referenceToData.first!["file1"], "I'm a modified text file".toData)
  }

  func testItCanFilterOutGivenFilenames() {
    let contents: [String: Data] = ["file1": "I'm a text file".toData]

    let data = ResourceData(contents)

    XCTAssertEqual(data.fileNames, ["file1"])
  }
}
