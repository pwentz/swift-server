import XCTest
import Requests
import Responses
@testable import ResponseFormatters

class ParamsFormatterTest: XCTestCase {
  let ok = TwoHundred.Ok

  func testItCanHandleNoParams() {
    let request = HTTPRequest(for: "GET /parameters HTTP/1.1\r\n")!
    let response = HTTPResponse(status: ok)

    let newResponse = ParamsFormatter(for: request.params).addToResponse(response)

    XCTAssertNil(newResponse.body)
  }

  func testItCanHandleSimpleParams() {
    let rawRequest = "GET /parameters?variable_1=Operators HTTP/1.1\r\n"
    let request = HTTPRequest(for: rawRequest)!
    let response = HTTPResponse(status: ok)

    let newResponse = ParamsFormatter(for: request.params).addToResponse(response)

    let expectedResponse = HTTPResponse(
      status: ok,
      body: "variable_1 = Operators"
    )

    XCTAssertEqual(newResponse, expectedResponse)
  }

  func testItCanDecodeComplexParams() {
    let rawRequest = "GET /parameters?variable_1=Operators%20%3C%2C%20%3E%2C%20%3D%2C%20!%3D%3B%20%2B%2C%20-%2C%20*%2C%20%26%2C%20%40%2C%20%23%2C%20%24%2C%20%5B%2C%20%5D%3A%20%22is%20that%20all%22%3F HTTP/1.1\r\n"
    let request = HTTPRequest(for: rawRequest)!
    let response = HTTPResponse(status: ok)

    let newResponse = ParamsFormatter(for: request.params).addToResponse(response)

    let expectedResponse = HTTPResponse(
      status: ok,
      body: "variable_1 = Operators <, >, =, !=; +, -, *, &, @, #, $, [, ]: \"is that all\"?"
    )

    XCTAssertEqual(newResponse, expectedResponse)
  }

  func testItCanDecodeAndAppendMultipleParams() {
    let paramOne = "variable_1=Operators%20%3C%2C%20%3E%2C%20%3D%2C%20!%3D%3B%20%2B%2C%20-%2C%20*%2C%20%26%2C%20%40%2C%20%23%2C%20%24%2C%20%5B%2C%20%5D%3A%20%22is%20that%20all%22%3F"
    let paramTwo = "variable_2=stuff"

    let rawRequest = "GET /parameters?\(paramOne)&\(paramTwo) HTTP/1.1\r\n"
    let request = HTTPRequest(for: rawRequest)!
    let response = HTTPResponse(status: ok, body: "wow")

    let newResponse = ParamsFormatter(for: request.params).addToResponse(response)

    let expectedResponse = HTTPResponse(
      status: ok,
      body: "wow\n\nvariable_1 = Operators <, >, =, !=; +, -, *, &, @, #, $, [, ]: \"is that all\"?\nvariable_2 = stuff"
    )

    XCTAssertEqual(newResponse, expectedResponse)
  }

  func testItDoesNotAppendParamsWhenParamsAreNil() {
    let rawRequest = "GET /parameters HTTP/1.1"
    let request = HTTPRequest(for: rawRequest)!
    let response = HTTPResponse(status: ok, body: "wow")

    let newResponse = ParamsFormatter(for: request.params).addToResponse(response)

    let expectedResponse = HTTPResponse(
      status: ok,
      body: "wow"
    )

    XCTAssertEqual(newResponse, expectedResponse)
  }

}
