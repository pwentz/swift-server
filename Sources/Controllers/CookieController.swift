import Requests
import Responses

public class CookieController: Controller {

  public static func process(_ request: Request) -> HTTPResponse {
    let status = 200

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

    return Response(status: status,
                    headers: headers,
                    body: Array(body.utf8))
  }

}
