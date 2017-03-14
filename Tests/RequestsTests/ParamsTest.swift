import XCTest
@testable import Requests

class ParamsTest: XCTestCase {
  func testItCanBeAString() {
    let fullPath = "/some_path?my=params"

    let params = Params(for: fullPath)

    XCTAssertEqual(params.toString(), "my=params")
  }

  func testItCanBeADynamicString() {
    let fullPath = "/some_path?type=oatmeal"

    let params = Params(for: fullPath)

    XCTAssertEqual(params.toString(), "type=oatmeal")
  }

  func testItHasKeys() {
    let fullPath = "/some_path?type=oatmeal"

    let params = Params(for: fullPath)

    XCTAssertEqual(params.keys(), ["type"])
  }

  func testItHasDynamicKeys() {
    let fullPath = "/some_path?my=params"

    let params = Params(for: fullPath)

    XCTAssertEqual(params.keys(), ["my"])
  }

  func testItHasValues() {
    let fullPath = "/some_path?type=oatmeal"

    let params = Params(for: fullPath)

    XCTAssertEqual(params.values(), ["oatmeal"])
  }

  func testItHasDynamicValues() {
    let fullPath = "/some_path?type=chocolate"

    let params = Params(for: fullPath)

    XCTAssertEqual(params.values(), ["chocolate"])
  }

  func testItCanHandleBlankParamsToString() {
    let fullPath = "/some_path?type="

    let params = Params(for: fullPath)

    XCTAssertEqual(params.toString(), "type=")
  }

  func testItCanHandleBlankParamsKeys() {
    let fullPath = "/some_path?type="

    let params = Params(for: fullPath)

    XCTAssertEqual(params.keys(), ["type"])
  }

  func testItCanHandleBlankParamsValues() {
    let fullPath = "/some_path?type="

    let params = Params(for: fullPath)

    XCTAssertEqual(params.values(), [""])
  }

  func testItCanZipParams() {
    let fullPath = "/some_path?type=oatmeal"

    let params = Params(for: fullPath)

    XCTAssertEqual(params.zip(), ["type": "oatmeal"])
  }

  func testItCanDynamicallyZipParams() {
    let fullPath = "/some_path?my=params"

    let params = Params(for: fullPath)

    XCTAssertEqual(params.zip(), ["my": "params"])
  }
}
