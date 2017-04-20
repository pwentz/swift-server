import XCTest
import Requests
import Responses
@testable import ResponseFormatters

class ParamsFormatterTest: XCTestCase {
  func testItCanHandleNoParams() {
    let rawRequest = "GET /parameters HTTP/1.1\r\nHost: localhost:5000\r\nConnection: Keep-Alive\r\nUser-Agent: Apache-HttpClient/4.3.5 (java 1.5)\r\nAccept-Encoding: gzip,deflate"
    let request = HTTPRequest(for: rawRequest)!
    let response = HTTPResponse(status: TwoHundred.Ok)

    let newResponse = ParamsFormatter(for: request.params).addToResponse(response)

    XCTAssertNil(newResponse.body)
  }

  func testItCanDecodeSimpleParams() {
    let rawRequest = "GET /parameters?variable_1=Operators HTTP/1.1\r\nHost: localhost:5000\r\nConnection: Keep-Alive\r\nUser-Agent: Apache-HttpClient/4.3.5 (java 1.5)\r\nAccept-Encoding: gzip,deflate"
    let request = HTTPRequest(for: rawRequest)!
    let response = HTTPResponse(status: TwoHundred.Ok)

    let newResponse = ParamsFormatter(for: request.params).addToResponse(response)
    let expected = "variable_1 = Operators"

    XCTAssertEqual(newResponse.body!.toBytes, expected.toBytes)
  }

  func testItCanDecodeComplexParams() {
    let rawRequest = "GET /parameters?variable_1=Operators%20%3C%2C%20%3E%2C%20%3D%2C%20!%3D%3B%20%2B%2C%20-%2C%20*%2C%20%26%2C%20%40%2C%20%23%2C%20%24%2C%20%5B%2C%20%5D%3A%20%22is%20that%20all%22%3F HTTP/1.1\r\nHost: localhost:5000\r\nConnection: Keep-Alive\r\nUser-Agent: Apache-HttpClient/4.3.5 (java 1.5)\r\nAccept-Encoding: gzip,deflate"
    let request = HTTPRequest(for: rawRequest)!
    let response = HTTPResponse(status: TwoHundred.Ok)

    let newResponse = ParamsFormatter(for: request.params).addToResponse(response)
    let expected = "variable_1 = Operators <, >, =, !=; +, -, *, &, @, #, $, [, ]: \"is that all\"?"

    XCTAssertEqual(newResponse.body!.toBytes, expected.toBytes)
  }

  func testItCanDecodeAndFormatMultipleParams() {
    let rawRequest = "GET /parameters?variable_1=Operators%20%3C%2C%20%3E%2C%20%3D%2C%20!%3D%3B%20%2B%2C%20-%2C%20*%2C%20%26%2C%20%40%2C%20%23%2C%20%24%2C%20%5B%2C%20%5D%3A%20%22is%20that%20all%22%3F&variable_2=stuff HTTP/1.1\r\nHost: localhost:5000\r\nConnection: Keep-Alive\r\nUser-Agent: Apache-HttpClient/4.3.5 (java 1.5)\r\nAccept-Encoding: gzip,deflate"
    let request = HTTPRequest(for: rawRequest)!
    let response = HTTPResponse(status: TwoHundred.Ok)

    let newResponse = ParamsFormatter(for: request.params).addToResponse(response)
    let expected = "variable_1 = Operators <, >, =, !=; +, -, *, &, @, #, $, [, ]: \"is that all\"?\nvariable_2 = stuff"

    XCTAssertEqual(newResponse.body!.toBytes, expected.toBytes)
  }

  func testItAppendParamsToExistingBody() {
    let rawRequest = "GET /parameters?variable_1=Operators%20%3C%2C%20%3E%2C%20%3D%2C%20!%3D%3B%20%2B%2C%20-%2C%20*%2C%20%26%2C%20%40%2C%20%23%2C%20%24%2C%20%5B%2C%20%5D%3A%20%22is%20that%20all%22%3F&variable_2=stuff HTTP/1.1\r\nHost: localhost:5000\r\nConnection: Keep-Alive\r\nUser-Agent: Apache-HttpClient/4.3.5 (java 1.5)\r\nAccept-Encoding: gzip,deflate"
    let request = HTTPRequest(for: rawRequest)!
    let response = HTTPResponse(status: TwoHundred.Ok, body: "wow")

    let newResponse = ParamsFormatter(for: request.params).addToResponse(response)
    let expected = "wow\n\nvariable_1 = Operators <, >, =, !=; +, -, *, &, @, #, $, [, ]: \"is that all\"?\nvariable_2 = stuff"

    XCTAssertEqual(newResponse.body!.toBytes, expected.toBytes)
  }

  func testItDoesNotAppendParamsWhenParamsAreNil() {
    let rawRequest = "GET /parameters HTTP/1.1\r\nHost: localhost:5000\r\nConnection: Keep-Alive\r\nUser-Agent: Apache-HttpClient/4.3.5 (java 1.5)\r\nAccept-Encoding: gzip,deflate"
    let request = HTTPRequest(for: rawRequest)!
    let response = HTTPResponse(status: TwoHundred.Ok, body: "wow")

    let newResponse = ParamsFormatter(for: request.params).addToResponse(response)

    XCTAssertEqual(newResponse.body!.toBytes, "wow".toBytes)
  }

}
