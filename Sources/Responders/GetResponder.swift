import Foundation
import Util
import Routes
import Requests
import Responses

class GetResponder {
  let route: Route
  let data: ControllerData

  public init(route: Route, data: ControllerData) {
    self.route = route
    self.data = data
  }

  public func respond(to request: Request, logs: [String]) -> Response {
    var newResponse = HTTPResponse(status: TwoHundred.Ok)

    ContentResponder(for: request, data: data).execute(on: &newResponse)

    CookieResponder(for: request, prefix: route.cookiePrefix).execute(on: &newResponse)

    LogsResponder(for: request, logs: route.includeLogs ? logs : nil).execute(on: &newResponse)

    if route.includeDirectoryLinks {
      let fileLinks = data.fileNames().map { file in
        "<a href=\"/\(file)\">\(file)</a>"
      }.joined(separator: "<br>")

      newResponse.appendToBody(fileLinks)
    }

    PartialResponder(for: request).execute(on: &newResponse)


    return newResponse
  }

}
