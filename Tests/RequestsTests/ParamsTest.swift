import XCTest
@testable import Requests

class ParamsTest: XCTestCase {
  func testItCanBeAString() {
    let fullPath = "my=params"

    let params = HTTPParameters(for: fullPath)!

    XCTAssertEqual(String(params: params)!, "my=params")
  }

  func testItCanBeADynamicString() {
    let fullPath = "type=oatmeal"

    let params = HTTPParameters(for: fullPath)!

    XCTAssertEqual(String(params: params)!, "type=oatmeal")
  }

  func testItHasKeys() {
    let fullPath = "type=oatmeal"

    let params = HTTPParameters(for: fullPath)!

    XCTAssertEqual(params.keys, ["type"])
  }

  func testItHasDynamicKeys() {
    let fullPath = "my=params"

    let params = HTTPParameters(for: fullPath)!

    XCTAssertEqual(params.keys, ["my"])
  }

  func testItHasValues() {
    let fullPath = "type=oatmeal"

    let params = HTTPParameters(for: fullPath)!

    XCTAssertEqual(params.values, ["oatmeal"])
  }

  func testItHasDynamicValues() {
    let fullPath = "type=chocolate"

    let params = HTTPParameters(for: fullPath)!

    XCTAssertEqual(params.values, ["chocolate"])
  }

  func testItCantHandleSingleMissingValue() {
    let fullPath = "type="

    let params = HTTPParameters(for: fullPath)

    XCTAssertNil(params)
  }

  func testItCanHandleNestedBlankParamValuesToString() {
    let fullPath = "type=chocolate&wow="

    let params = HTTPParameters(for: fullPath)!

    XCTAssertEqual(String(params: params)!, "type=chocolate")
  }

  func testItCanHandleNestedBlankParamKeysToString() {
    let fullPath = "type=chocolate&=wow"

    let params = HTTPParameters(for: fullPath)!

    XCTAssertEqual(String(params: params)!, "type=chocolate")
  }

  func testItCantHandleSingleMissingKey() {
    let fullPath = "=stuff"

    let params = HTTPParameters(for: fullPath)

    XCTAssertNil(params)
  }

  func testItCanHandleNestedInvalidParamsToDict() {
    let path = "type=chocolate&stuff="
    let params = HTTPParameters(for: path)!
    let result = [String: String](params: params)

    XCTAssertEqual(result, ["type": "chocolate"])
  }

  func testItCanHandleNestedInvalidParamsKeys() {
    let path = "type=chocolate&stuff="
    let params = HTTPParameters(for: path)!

    XCTAssertEqual(params.keys, ["type"])
  }

  func testItCanHandleNestedInvalidParamsVals() {
    let path = "type=chocolate&=stuff"
    let params = HTTPParameters(for: path)!

    XCTAssertEqual(params.values, ["chocolate"])
  }

  func testItCanConvertToDictionary() {
    let fullPath = "type=oatmeal"

    let params = HTTPParameters(for: fullPath)!
    let result = [String: String](params: params)

    XCTAssertEqual(result, ["type": "oatmeal"])
  }

  func testItCanDynamicallyConvertToDictionary() {
    let fullPath = "my=params"

    let params = HTTPParameters(for: fullPath)!
    let result = [String: String](params: params)

    XCTAssertEqual(result, ["my": "params"])
  }

  func testItCanHandleMultipleParamsToString() {
    let fullPath = "my=params&cool=stuff"

    let params = HTTPParameters(for: fullPath)!

    XCTAssertEqual(String(params: params)!, "my=params\ncool=stuff")
  }

  func testItCanHandleMultipleParamsKeys() {
    let fullPath = "my=params&cool=stuff"

    let params = HTTPParameters(for: fullPath)!

    XCTAssertEqual(params.keys, ["my", "cool"])
  }

  func testItCanHandleMultipleParamsVals() {
    let fullPath = "my=params&cool=stuff"

    let params = HTTPParameters(for: fullPath)!

    XCTAssertEqual(params.values, ["params", "stuff"])
  }

  func testItCanHandleInvalidNestedParamKeys() {
    let fullPath = "my=params&=cool"

    let params = HTTPParameters(for: fullPath)!
    let result = [String: String](params: params)

    XCTAssertEqual(result, ["my": "params"])
  }

  func testItCanHandleInvalidNestedParamVals() {
    let fullPath = "my=params&cool"

    let params = HTTPParameters(for: fullPath)!
    let result = [String: String](params: params)

    XCTAssertEqual(result, ["my": "params"])
  }

  func testItCanHandleMultipleParamsToDict() {
    let fullPath = "my=params&cool=stuff"

    let params = HTTPParameters(for: fullPath)!
    let result = [String: String](params: params)

    XCTAssertEqual(result, ["my": "params", "cool": "stuff"])
  }

  func testItCanHandleEncodedParamsToString() {
    let fullPath = "variable_1=Operators%20%3C%2C%20%3E%2C%20%3D%2C%20!%3D%3B%20%2B%2C%20-%2C%20*%2C%20%26%2C%20%40%2C%20%23%2C%20%24%2C%20%5B%2C%20%5D%3A%20%22is%20that%20all%22%3F&variable_2=stuff"

    let params = HTTPParameters(for: fullPath)!
    let expected = "variable_1=Operators <, >, =, !=; +, -, *, &, @, #, $, [, ]: \"is that all\"?\nvariable_2=stuff"

    XCTAssertEqual(String(params: params)!, expected)
  }

  func testItCanHandleEncodedParamsKeys() {
    let fullPath = "variable_1=Operators%20%3C%2C%20%3E%2C%20%3D&variable_2=stuff"

    let params = HTTPParameters(for: fullPath)!

    XCTAssertEqual(params.keys, ["variable_1", "variable_2"])
  }

  func testItCanHandleEncodedParamsVals() {
    let fullPath = "variable_1=Operators%20%3C%2C%20%3E%2C%20%3D%2C%20!%3D%3B%20%2B%2C%20-%2C%20*%2C%20%26%2C%20%40%2C%20%23%2C%20%24%2C%20%5B%2C%20%5D%3A%20%22is%20that%20all%22%3F&variable_2=stuff"

    let params = HTTPParameters(for: fullPath)!
    let expected = ["Operators <, >, =, !=; +, -, *, &, @, #, $, [, ]: \"is that all\"?", "stuff"]

    XCTAssertEqual(params.values, expected)
  }

  func testItCanHandleEncodedParamsToDict() {
    let fullPath = "variable_1=Operators%20%3C%2C%20%3E%2C%20%3D%2C%20!%3D%3B%20%2B%2C%20-%2C%20*%2C%20%26%2C%20%40%2C%20%23%2C%20%24%2C%20%5B%2C%20%5D%3A%20%22is%20that%20all%22%3F&variable_2=stuff"

    let params = HTTPParameters(for: fullPath)!
    let expected = ["variable_1": "Operators <, >, =, !=; +, -, *, &, @, #, $, [, ]: \"is that all\"?", "variable_2": "stuff"]
    let result = [String: String](params: params)

      XCTAssertEqual(result, expected)
  }

  func testItCanHandleNonEncodedParams() {
    let fullPath = "variable_1=Operators%k0%-3C%2!C%2m%3j%&variable_2=stuff"

    let params = HTTPParameters(for: fullPath)!
    let expected = ["variable_1": "Operators%k0%-3C%2!C%2m%3j%", "variable_2": "stuff"]
    let result = [String: String](params: params)

    XCTAssertEqual(result, expected)
  }
}
