import XCTest
@testable import Requests
@testable import Controllers

class PatchedContentControllerTest: XCTestCase {
  func testItCanReturnDefaultStatusOnGet() {
    let rawRequest = "GET /patch-content.txt HTTP/1.1\r\nHost: localhost:5000\r\nConnection: Keep-Alive\r\nUser-Agent: Apache-HttpClient/4.3.5 (java 1.5)\r\nAccept-Encoding: gzip,deflate"
    let request = Request(for: rawRequest)

    let contents: [String: [UInt8]] = ["patch-content.txt": Array("default content".utf8)]

    let response = PatchedContentController(contents: contents).process(request)

    let expected = Array("\n\ndefault content".utf8)

    XCTAssertEqual(response.statusCode, "200 OK")
  }

  // func testItCanReturnDefaultContentOnGet() {
  //   let rawRequest = "GET /patch-content.txt HTTP/1.1\r\nHost: localhost:5000\r\nConnection: Keep-Alive\r\nUser-Agent: Apache-HttpClient/4.3.5 (java 1.5)\r\nAccept-Encoding: gzip,deflate"
  //   let request = Request(for: rawRequest)

  //   let contents: [String: [UInt8]] = ["patch-content.txt": Array("default content".utf8)]

  //   let response = PatchedContentController(contents: contents).process(request)

  //   let expected = Array("\n\ndefault content".utf8)

  //   XCTAssertEqual(response.body!, expected)
  // }

  func testItCanReturn204WhenSentPatch() {
    let rawRequest = "PATCH /patch-content.txt HTTP/1.1\r\nHost: localhost:5000\r\nConnection: Keep-Alive\r\nIf-Match: dc50a0d27dda2eee9f65644cd7e4c9cf11de8bec\r\nContent-Length: 15\r\nUser-Agent: Apache-HttpClient/4.3.5 (java 1.5)\r\nAccept-Encoding: gzip,deflate\r\npatched content"
    let request = Request(for: rawRequest)

    let contents: [String: [UInt8]] = ["patch-content.txt": Array("default content".utf8)]

    let response = PatchedContentController(contents: contents).process(request)

    XCTAssertEqual(response.statusCode, "204 No Content")
  }

  func testItCanModifyDefaultContent() {
    let rawPatchRequest = "PATCH /patch-content.txt HTTP/1.1\r\nHost: localhost:5000\r\nConnection: Keep-Alive\r\nIf-Match: dc50a0d27dda2eee9f65644cd7e4c9cf11de8bec\r\nContent-Length: 15\r\nUser-Agent: Apache-HttpClient/4.3.5 (java 1.5)\r\nAccept-Encoding: gzip,deflate\r\npatched content"
    let rawGetRequest = "GET /patch-content.txt HTTP/1.1\r\nHost: localhost:5000\r\nConnection: Keep-Alive\r\nUser-Agent: Apache-HttpClient/4.3.5 (java 1.5)\r\nAccept-Encoding: gzip,deflate"
    let patchRequest = Request(for: rawPatchRequest)
    let getRequest = Request(for: rawGetRequest)

    let contents: [String: [UInt8]] = ["patch-content.txt": Array("default content".utf8)]

    let _ = PatchedContentController(contents: contents).process(patchRequest)

    let response = PatchedContentController(contents: contents).process(getRequest)

    let expected = Array("\n\npatched content".utf8)

    XCTAssertEqual(response.body!, expected)
  }
}
