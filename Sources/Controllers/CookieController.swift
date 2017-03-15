import Requests
import Responses

public class CookieController: Controller {
  static var cookie: [String: String] = [:]

  static public func process(_ request: Request) -> FormattedResponse {
    let status = 200

    var body: String = ""
    var headers: [String: String] = ["Content-Type": "text/html"]

    if let params = request.params {
      body = "Eat"

      cookie = params.zip()

      headers.updateValue(params.toString(), forKey: "Set-Cookie")
    }

    if request.headers["cookie"] != nil {
      body = "mmmm \(cookie["type"] ?? "")"
    }

    return FormattedResponse(status: status,
                             headers: headers,
                             body: body)
  }
}
