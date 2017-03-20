import Requests
import Responses

public class CookieController: Controller {
  public func process(_ request: Request) -> Response {
    let status = 200

    var body: String = ""
    var headers: [String: String] = ["Content-Type": "text/html"]

    if let params = request.params {
      body = "Eat"

      headers.updateValue(params.toString(), forKey: "Set-Cookie")
    }

    if let cookie = request.headers["cookie"] {
      let cookieValue = cookie.components(separatedBy: "=").last ?? ""
      body = "mmmm \(cookieValue)"
    }

    return Response(status: status,
                    headers: headers,
                    body: body)
  }
}
