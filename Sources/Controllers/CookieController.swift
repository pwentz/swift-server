import Requests
import Responses

public class CookieController: Controller {
  static var cookie: [String: String] = [:]

  static public func process(_ request: Request) -> Response {
    let status = 200

    var body: String = ""
    var headers: [String: String] = ["Content-Type": "text/html"]

    if let params = request.params {
      body = "Eat"

      cookie = params.toDictionary()

      headers.updateValue(params.toString(), forKey: "Set-Cookie")
    }

    if request.headers["cookie"] != nil {
      body = "mmmm \(cookie["type"] ?? "")"
    }

    return Response(status: status,
                    headers: headers,
                    body: body)
  }
}
