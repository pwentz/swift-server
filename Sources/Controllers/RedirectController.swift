import Requests
import Responses

public class RedirectController: Controller {

  public func process(_ request: Request) -> Response {
    let headers: [String: String] = ["Location": "/"]

    return Response(
      status: 302,
      headers: headers,
      body: nil
    )
  }
}
