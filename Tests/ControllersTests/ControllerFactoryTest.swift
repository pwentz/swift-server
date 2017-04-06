import XCTest
@testable import Controllers
import Requests
import Util

class ControllerFactoryTest: XCTestCase {
  func testItUpdatesLogsContent() {
    let rawRequest = "GET /dandkajjnw HTTP/1.1\r\n Host: localhost:5000\r\n Connection: Keep-Alive\r\n User-Agent: Apache-HttpClient/4.3.5 (java 1.5)\r\n Accept-Encoding: gzip,deflate"

    let request = HTTPRequest(for: rawRequest)

    let contents: [String: Data] = ["file1": Data(value: "I'm a text file"), "logs": Data(value: "")]
    let data = ControllerData(contents)

    let controller = ControllerFactory.getController(request, with: data)

    XCTAssertEqual(data.get("logs"), "\nGET /dandkajjnw HTTP/1.1")
  }

  func testItReturnsLogsControllerForLogsPath() {
    let rawRequest = "GET /logs HTTP/1.1\r\n Host: localhost:5000\r\n Connection: Keep-Alive\r\n User-Agent: Apache-HttpClient/4.3.5 (java 1.5)\r\n Accept-Encoding: gzip,deflate"

    let request = HTTPRequest(for: rawRequest)

    let contents: [String: Data] = ["file1": Data(value: "I'm a text file")]
    let data = ControllerData(contents)

    let controller = ControllerFactory.getController(request, with: data)

    XCTAssert(controller is LogsController)
  }

  func testItReturnsCookieControllerForCookiePaths() {
    let rawRequest = "GET /cookie?type=chocolate HTTP/1.1\r\nHost: localhost:5000\r\nConnection: Keep-Alive\r\nUser-Agent: Apache-HttpClient/4.3.5 (java 1.5)\r\nAccept-Encoding: gzip,deflate"

    let request = HTTPRequest(for: rawRequest)

    let contents: [String: Data] = ["file1": Data(value: "I'm a text file")]
    let data = ControllerData(contents)

    let controller = ControllerFactory.getController(request, with: data)

    XCTAssert(controller is CookieController)
  }

  func testItReturnsRootControllerForRootPath() {
    let rawRequest = "GET / HTTP/1.1\r\nHost: localhost:5000\r\nConnection: Keep-Alive\r\nUser-Agent: Apache-HttpClient/4.3.5 (java 1.5)\r\nAccept-Encoding: gzip,deflate"

    let request = HTTPRequest(for: rawRequest)

    let contents: [String: Data] = ["file1": Data(value: "I'm a text file")]
    let data = ControllerData(contents)

    let controller = ControllerFactory.getController(request, with: data)

    XCTAssert(controller is RootController)
  }

  func testItReturnsResourcesControllerForResourcesPath() {
    let rawRequest = "GET /file1 HTTP/1.1\r\nHost: localhost:5000\r\nConnection: Keep-Alive\r\nUser-Agent: Apache-HttpClient/4.3.5 (java 1.5)\r\nAccept-Encoding: gzip,deflate"

    let request = HTTPRequest(for: rawRequest)

    let contents: [String: Data] = ["file1": Data(value: "I'm a text file")]
    let data = ControllerData(contents)

    let controller = ControllerFactory.getController(request, with: data)

    XCTAssert(controller is ResourcesController)
  }

  func testItReturnsFoobarControllerForFoobarPath() {
    let rawRequest = "GET /foobar HTTP/1.1\r\nHost: localhost:5000\r\nConnection: Keep-Alive\r\nUser-Agent: Apache-HttpClient/4.3.5 (java 1.5)\r\nAccept-Encoding: gzip,deflate"

    let request = HTTPRequest(for: rawRequest)

    let contents: [String: Data] = ["file1": Data(value: "I'm a text file")]
    let data = ControllerData(contents)

    let controller = ControllerFactory.getController(request, with: data)

    XCTAssert(controller is FoobarController)
  }

  func testItReturnsCoffeeControllerForCoffeePath() {
    let rawRequest = "GET /coffee HTTP/1.1\r\nHost: localhost:5000\r\nConnection: Keep-Alive\r\nUser-Agent: Apache-HttpClient/4.3.5 (java 1.5)\r\nAccept-Encoding: gzip,deflate"

    let request = HTTPRequest(for: rawRequest)

    let contents: [String: Data] = ["file1": Data(value: "I'm a text file")]
    let data = ControllerData(contents)

    let controller = ControllerFactory.getController(request, with: data)

    XCTAssert(controller is CoffeeController)
  }

  func testItReturnsParametersControllerForParametersPath() {
    let rawRequest = "GET /parameters HTTP/1.1\r\nHost: localhost:5000\r\nConnection: Keep-Alive\r\nUser-Agent: Apache-HttpClient/4.3.5 (java 1.5)\r\nAccept-Encoding: gzip,deflate"

    let request = HTTPRequest(for: rawRequest)

    let contents: [String: Data] = ["file1": Data(value: "I'm a text file")]
    let data = ControllerData(contents)

    let controller = ControllerFactory.getController(request, with: data)

    XCTAssert(controller is ParametersController)
  }

  func testItReturnsFormControllerForFormPath() {
    let rawRequest = "GET /form HTTP/1.1\r\nHost: localhost:5000\r\nConnection: Keep-Alive\r\nUser-Agent: Apache-HttpClient/4.3.5 (java 1.5)\r\nAccept-Encoding: gzip,deflate"

    let request = HTTPRequest(for: rawRequest)

    let contents: [String: Data] = ["file1": Data(value: "I'm a text file")]
    let data = ControllerData(contents)

    let controller = ControllerFactory.getController(request, with: data)

    XCTAssert(controller is FormController)
  }

  func testItReturnsRedirectControllerForRedirectPath() {
    let rawRequest = "GET /redirect HTTP/1.1\r\nHost: localhost:5000\r\nConnection: Keep-Alive\r\nUser-Agent: Apache-HttpClient/4.3.5 (java 1.5)\r\nAccept-Encoding: gzip,deflate"

    let request = HTTPRequest(for: rawRequest)

    let contents: [String: Data] = ["file1": Data(value: "I'm a text file")]
    let data = ControllerData(contents)

    let controller = ControllerFactory.getController(request, with: data)

    XCTAssert(controller is RedirectController)
  }

  func testItReturnsMethodOptionsControllerForMethodOptionsPath() {
    let rawRequest = "GET /method_options2 HTTP/1.1\r\nHost: localhost:5000\r\nConnection: Keep-Alive\r\nUser-Agent: Apache-HttpClient/4.3.5 (java 1.5)\r\nAccept-Encoding: gzip,deflate"

    let request = HTTPRequest(for: rawRequest)

    let contents: [String: Data] = ["file1": Data(value: "I'm a text file")]
    let data = ControllerData(contents)

    let controller = ControllerFactory.getController(request, with: data)

    XCTAssert(controller is MethodOptionsController)
  }

  func testItReturnsDefaultControllerForAllOtherRoutes() {
    let rawRequest = "GET /some_random_route HTTP/1.1\r\nHost: localhost:5000\r\nConnection: Keep-Alive\r\nUser-Agent: Apache-HttpClient/4.3.5 (java 1.5)\r\nAccept-Encoding: gzip,deflate"

    let request = HTTPRequest(for: rawRequest)

    let contents: [String: Data] = ["file1": Data(value: "I'm a text file")]
    let data = ControllerData(contents)

    let controller = ControllerFactory.getController(request, with: data)

    XCTAssert(controller is DefaultController)
  }
}
