import Requests
import Responses

public class RedirectController: Controller {

  public static func process(_ request: Request) -> HTTPResponse {
    let headers: [String: String] = ["Location": "/"]

    return Response(
      status: 302,
      headers: headers,
      body: nil
    )
  }

}
