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

  func testItCanConvertToDictionary() {
    let fullPath = "/some_path?type=oatmeal"

    let params = Params(for: fullPath)

    XCTAssertEqual(params.toDictionary(), ["type": "oatmeal"])
  }

  func testItCanDynamicallyConvertToDictionary() {
    let fullPath = "/some_path?my=params"

    let params = Params(for: fullPath)

    XCTAssertEqual(params.toDictionary(), ["my": "params"])
  }

  func testItCanHandleMultipleParamsToString() {
    let fullPath = "/some_path?my=params&cool=stuff"

    let params = Params(for: fullPath)

    XCTAssertEqual(params.toString(), "my=params\ncool=stuff")
  }

  func testItCanHandleMultipleParamsKeys() {
    let fullPath = "/some_path?my=params&cool=stuff"

    let params = Params(for: fullPath)

    XCTAssertEqual(params.keys(), ["my", "cool"])
  }

  func testItCanHandleMultipleParamsVals() {
    let fullPath = "/some_path?my=params&cool=stuff"

    let params = Params(for: fullPath)

    XCTAssertEqual(params.values(), ["params", "stuff"])
  }

  func testItCanHandleMultipleParamsToDict() {
    let fullPath = "/some_path?my=params&cool=stuff"

    let params = Params(for: fullPath)

    XCTAssertEqual(params.toDictionary(), ["my": "params", "cool": "stuff"])
  }

  func testItCanHandleEncodedParamsToString() {
    let fullPath = "/parameters?variable_1=Operators%20%3C%2C%20%3E%2C%20%3D%2C%20!%3D%3B%20%2B%2C%20-%2C%20*%2C%20%26%2C%20%40%2C%20%23%2C%20%24%2C%20%5B%2C%20%5D%3A%20%22is%20that%20all%22%3F&variable_2=stuff"

    let params = Params(for: fullPath)
    let expected = "variable_1=Operators <, >, =, !=; +, -, *, &, @, #, $, [, ]: \"is that all\"?\nvariable_2=stuff"

    XCTAssertEqual(params.toString(), expected)
  }

  func testItCanHandleEncodedParamsKeys() {
    let fullPath = "/parameters?variable_1=Operators%20%3C%2C%20%3E%2C%20%3D&variable_2=stuff"

    let params = Params(for: fullPath)

    XCTAssertEqual(params.keys(), ["variable_1", "variable_2"])
  }

  func testItCanHandleEncodedParamsVals() {
    let fullPath = "/parameters?variable_1=Operators%20%3C%2C%20%3E%2C%20%3D%2C%20!%3D%3B%20%2B%2C%20-%2C%20*%2C%20%26%2C%20%40%2C%20%23%2C%20%24%2C%20%5B%2C%20%5D%3A%20%22is%20that%20all%22%3F&variable_2=stuff"

    let params = Params(for: fullPath)
    let expected = ["Operators <, >, =, !=; +, -, *, &, @, #, $, [, ]: \"is that all\"?", "stuff"]

    XCTAssertEqual(params.values(), expected)
  }

  func testItCanHandleEncodedParamsToDict() {
    let fullPath = "/parameters?variable_1=Operators%20%3C%2C%20%3E%2C%20%3D%2C%20!%3D%3B%20%2B%2C%20-%2C%20*%2C%20%26%2C%20%40%2C%20%23%2C%20%24%2C%20%5B%2C%20%5D%3A%20%22is%20that%20all%22%3F&variable_2=stuff"

    let params = Params(for: fullPath)
    let expected = ["variable_1": "Operators <, >, =, !=; +, -, *, &, @, #, $, [, ]: \"is that all\"?", "variable_2": "stuff"]

    XCTAssertEqual(params.toDictionary(), expected)
  }
}
