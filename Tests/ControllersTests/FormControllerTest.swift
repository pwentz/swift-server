import XCTest
@testable import Requests
@testable import Controllers

class FormControllerTest: XCTestCase {
  func testItReturnsEmptyOnInitialGet() {
    let rawRequest = "GET /form HTTP/1.1\r\nHost:\r\nConnection:Keep-Alive\r\nUser-Agent:chrome\r\nAccept-Encoding:gzip,deflate"
    let request = Request(for: rawRequest)

    let response = FormController().process(request)

    XCTAssert(response.body == nil)
  }

  func testItSavesDataOnPostReturnsOnGet() {
    let rawPostRequest = "POST /form HTTP/1.1\r\nHost:\r\nConnection:Keep-Alive\r\nUser-Agent:chrome\r\nAccept-Encoding:gzip,deflate\r\ndata=fatcat"
    let rawGetRequest = "GET /form HTTP/1.1\r\nHost:\r\nConnection:Keep-Alive\r\nUser-Agent:chrome\r\nAccept-Encoding:gzip,deflate"
    let postRequest = Request(for: rawPostRequest)
    let getRequest = Request(for: rawGetRequest)

    let _ = FormController().process(postRequest)
    let response = FormController().process(getRequest)

    let expected = Array("\n\ndata=fatcat".utf8)

    XCTAssertEqual(response.body!, expected)
  }

  func testItUpdatesDataOnPutRequests() {
    let rawPostRequest = "POST /form HTTP/1.1\r\nHost:\r\nConnection:Keep-Alive\r\nUser-Agent:chrome\r\nAccept-Encoding:gzip,deflate\r\ndata=fatcat"
    let rawPutRequest = "PUT /form HTTP/1.1\r\nHost:\r\nConnection:Keep-Alive\r\nUser-Agent:chrome\r\nAccept-Encoding:gzip,deflate\r\ndata=hamilton"
    let rawGetRequest = "GET /form HTTP/1.1\r\nHost:\r\nConnection:Keep-Alive\r\nUser-Agent:chrome\r\nAccept-Encoding:gzip,deflate"
    let postRequest = Request(for: rawPostRequest)
    let putRequest = Request(for: rawPutRequest)
    let getRequest = Request(for: rawGetRequest)

    let _ = FormController().process(postRequest)
    let _ = FormController().process(putRequest)
    let response = FormController().process(getRequest)

    let expected = Array("\n\ndata=hamilton".utf8)

    XCTAssertEqual(response.body!, expected)
  }

  func testItRemovesDataOnDelete() {
    let rawPostRequest = "POST /form HTTP/1.1\r\nHost:\r\nConnection:Keep-Alive\r\nUser-Agent:chrome\r\nAccept-Encoding:gzip,deflate\r\ndata=fatcat"
    let rawDeleteRequest = "DELETE /form HTTP/1.1\r\nHost:\r\nConnection:Keep-Alive\r\nUser-Agent:chrome\r\nAccept-Encoding:gzip,deflate"
    let rawGetRequest = "GET /form HTTP/1.1\r\nHost:\r\nConnection:Keep-Alive\r\nUser-Agent:chrome\r\nAccept-Encoding:gzip,deflate"
    let postRequest = Request(for: rawPostRequest)
    let deleteRequest = Request(for: rawDeleteRequest)
    let getRequest = Request(for: rawGetRequest)

    let _ = FormController().process(postRequest)
    let _ = FormController().process(deleteRequest)
    let response = FormController().process(getRequest)

    XCTAssert(response.body == nil)
  }
}
