import XCTest
import Util
@testable import Requests
@testable import Controllers

class FormControllerTest: XCTestCase {
  func testItReturnsEmptyOnInitialGet() {
    let rawRequest = "GET /form HTTP/1.1\r\nHost:\r\nConnection:Keep-Alive\r\nUser-Agent:chrome\r\nAccept-Encoding:gzip,deflate"
    let request = HTTPRequest(for: rawRequest)

    let contents: ControllerData = ControllerData(["form": Data(value: "")])

    let response = FormController(contents: contents).process(request)

    XCTAssert(response.body == nil)
  }

  func testItSavesDataOnPostReturnsOnGet() {
    let rawPostRequest = "POST /form HTTP/1.1\r\nHost:\r\nConnection:Keep-Alive\r\nUser-Agent:chrome\r\nAccept-Encoding:gzip,deflate\r\ndata=fatcat"
    let rawGetRequest = "GET /form HTTP/1.1\r\nHost:\r\nConnection:Keep-Alive\r\nUser-Agent:chrome\r\nAccept-Encoding:gzip,deflate"
    let postRequest = HTTPRequest(for: rawPostRequest)
    let getRequest = HTTPRequest(for: rawGetRequest)

    let contents: ControllerData = ControllerData(["form": Data(value: "")])

    let _ = FormController(contents: contents).process(postRequest)
    let response = FormController(contents: contents).process(getRequest)

    let expected = Array("\n\ndata=fatcat".utf8)

    XCTAssertEqual(response.body!, expected)
  }

  func testItUpdatesDataOnPutRequests() {
    let rawPostRequest = "POST /form HTTP/1.1\r\nHost:\r\nConnection:Keep-Alive\r\nUser-Agent:chrome\r\nAccept-Encoding:gzip,deflate\r\ndata=fatcat"
    let rawPutRequest = "PUT /form HTTP/1.1\r\nHost:\r\nConnection:Keep-Alive\r\nUser-Agent:chrome\r\nAccept-Encoding:gzip,deflate\r\ndata=hamilton"
    let rawGetRequest = "GET /form HTTP/1.1\r\nHost:\r\nConnection:Keep-Alive\r\nUser-Agent:chrome\r\nAccept-Encoding:gzip,deflate"
    let postRequest = HTTPRequest(for: rawPostRequest)
    let putRequest = HTTPRequest(for: rawPutRequest)
    let getRequest = HTTPRequest(for: rawGetRequest)

    let contents: ControllerData = ControllerData(["form": Data(value: "")])

    let _ = FormController(contents: contents).process(postRequest)
    let _ = FormController(contents: contents).process(putRequest)
    let response = FormController(contents: contents).process(getRequest)

    let expected = Array("\n\ndata=hamilton".utf8)

    XCTAssertEqual(response.body!, expected)
  }

  func testItRemovesDataOnDelete() {
    let rawPostRequest = "POST /form HTTP/1.1\r\nHost:\r\nConnection:Keep-Alive\r\nUser-Agent:chrome\r\nAccept-Encoding:gzip,deflate\r\ndata=fatcat"
    let rawDeleteRequest = "DELETE /form HTTP/1.1\r\nHost:\r\nConnection:Keep-Alive\r\nUser-Agent:chrome\r\nAccept-Encoding:gzip,deflate"
    let rawGetRequest = "GET /form HTTP/1.1\r\nHost:\r\nConnection:Keep-Alive\r\nUser-Agent:chrome\r\nAccept-Encoding:gzip,deflate"
    let postRequest = HTTPRequest(for: rawPostRequest)
    let deleteRequest = HTTPRequest(for: rawDeleteRequest)
    let getRequest = HTTPRequest(for: rawGetRequest)

    let contents: ControllerData = ControllerData(["form": Data(value: "")])

    let _ = FormController(contents: contents).process(postRequest)
    let _ = FormController(contents: contents).process(deleteRequest)
    let response = FormController(contents: contents).process(getRequest)

    XCTAssert(response.body == nil)
  }
}
