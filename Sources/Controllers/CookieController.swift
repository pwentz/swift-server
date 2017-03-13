import Requests
import Responses

public class CookieController {
  let request: Request

  public init(_ request: Request) {
    self.request = request
  }

  public func process() -> Response {
    let status = 200
    var body: String = "mmmm chocolate"
    var headers: [String: String] = ["Content-Type": "text/html"]

    if let params = request.params?.map({ "\($0)=\($1)" }).joined(separator: "") {
      body = "Eat"
      headers.updateValue(params,
                          forKey: "Set-Cookie")
    }

    return Response(status: status,
                    headers: headers,
                    body: body)
  }
}
