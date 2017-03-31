import Requests
import Responses

public class RedirectController: Controller {

  public func process(_ request: Request) -> Response {
    return HTTPResponse(status: ThreeHundred.Found,
                        headers: ["Location": "/"])
  }

}
