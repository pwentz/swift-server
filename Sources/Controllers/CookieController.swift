import Requests
import Responses

public class CookieController: Controller {

  public func process(_ request: Request) -> Response {
    var body: String = ""
    var headers: [String: String] = ["Content-Type": "text/html"]

    if let params = request.params {
      body = "Eat"

      headers["Set-Cookie"] = params.toString()
    }

    if let cookie = request.headers["cookie"] {
      let cookieValue = cookie.components(separatedBy: "=").last ?? ""
      body = "mmmm \(cookieValue)"
    }

    return Response(status: TwoHundred.Ok,
                    headers: headers,
                    body: Array(body.utf8))
  }

}
