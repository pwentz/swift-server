import Requests
import Responses
import Util

public class CookieController: Controller {

  public func process(_ request: Request) -> Response {
    var body: String = ""
    var headers: [String: String] = ["Content-Type": "text/html"]

    if let params = request.params {
      body = "Eat"

      String(parameters: params).map { headers["Set-Cookie"] = $0 }
    }

    if let cookie = request.headers["cookie"] {
      let cookieValue = cookie.components(separatedBy: "=").last ?? ""
      body = "mmmm \(cookieValue)"
    }

    return HTTPResponse(status: TwoHundred.Ok,
                        headers: headers,
                        body: body)
  }

}
