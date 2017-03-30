import Requests
import Responses

public class RedirectController: Controller {

  public func process(_ request: Request) -> Response {
    let headers: [String: String] = ["Location": "/"]

    return HTTPResponse(status: ThreeHundred.Found, headers: headers)
  }

}
