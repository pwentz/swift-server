import XCTest
@testable import Requests

class ParamsTest: XCTestCase {
  func testItCanBeAString() {
    let params = HTTPParameters(for: "my=params")!

    XCTAssertEqual(String(params: params)!, "my=params")
  }

  func testItCanBeADynamicString() {
    let params = HTTPParameters(for: "type=oatmeal")!

    XCTAssertEqual(String(params: params)!, "type=oatmeal")
  }

  func testItHasKeys() {
    let params = HTTPParameters(for: "type=oatmeal")!

    XCTAssertEqual(params.keys, ["type"])
  }

  func testItHasDynamicKeys() {
    let params = HTTPParameters(for: "my=params")!

    XCTAssertEqual(params.keys, ["my"])
  }

  func testItHasValues() {
    let params = HTTPParameters(for: "type=oatmeal")!

    XCTAssertEqual(params.values, ["oatmeal"])
  }

  func testItHasDynamicValues() {
    let params = HTTPParameters(for: "type=chocolate")!

    XCTAssertEqual(params.values, ["chocolate"])
  }

  func testItCantHandleSingleMissingValue() {
    let params = HTTPParameters(for: "type=")

    XCTAssertNil(params)
  }

  func testItCanHandleNestedBlankParamValuesToString() {
    let params = HTTPParameters(for: "type=chocolate&wow=")!

    XCTAssertEqual(String(params: params)!, "type=chocolate")
  }

  func testItCanHandleNestedBlankParamKeysToString() {
    let params = HTTPParameters(for: "type=chocolate&=wow")!

    XCTAssertEqual(String(params: params)!, "type=chocolate")
  }

  func testItCantHandleSingleMissingKey() {
    let params = HTTPParameters(for: "=stuff")

    XCTAssertNil(params)
  }

  func testItCanHandleNestedInvalidParamsToDict() {
    let params = HTTPParameters(for: "type=chocolate&stuff=")!
    let result = [String: String](params: params)

    XCTAssertEqual(result, ["type": "chocolate"])
  }

  func testItCanHandleNestedInvalidParamsKeys() {
    let params = HTTPParameters(for: "type=chocolate&stuff=")!

    XCTAssertEqual(params.keys, ["type"])
  }

  func testItCanHandleNestedInvalidParamsVals() {
    let params = HTTPParameters(for: "type=chocolate&=stuff")!

    XCTAssertEqual(params.values, ["chocolate"])
  }

  func testItCanConvertToDictionary() {
    let params = HTTPParameters(for: "type=oatmeal")!
    let result = [String: String](params: params)

    XCTAssertEqual(result, ["type": "oatmeal"])
  }

  func testItCanDynamicallyConvertToDictionary() {
    let params = HTTPParameters(for: "my=params")!
    let result = [String: String](params: params)

    XCTAssertEqual(result, ["my": "params"])
  }

  func testItCanHandleMultipleParamsToString() {
    let params = HTTPParameters(for: "my=params&cool=stuff")!

    XCTAssertEqual(String(params: params)!, "my=params\ncool=stuff")
  }

  func testItCanHandleMultipleParamsKeys() {
    let params = HTTPParameters(for: "my=params&cool=stuff")!

    XCTAssertEqual(params.keys, ["my", "cool"])
  }

  func testItCanHandleMultipleParamsVals() {
    let params = HTTPParameters(for: "my=params&cool=stuff")!

    XCTAssertEqual(params.values, ["params", "stuff"])
  }

  func testItCanHandleInvalidNestedParamKeys() {
    let params = HTTPParameters(for: "my=params&=cool")!
    let result = [String: String](params: params)

    XCTAssertEqual(result, ["my": "params"])
  }

  func testItCanHandleInvalidNestedParamVals() {
    let params = HTTPParameters(for: "my=params&cool")!
    let result = [String: String](params: params)

    XCTAssertEqual(result, ["my": "params"])
  }

  func testItCanHandleMultipleParamsToDict() {
    let params = HTTPParameters(for: "my=params&cool=stuff")!
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
