import Requests
import Responses

public class DefaultController: Controller {

  public func process(_ request: Request) -> Response {
    return HTTPResponse(status: TwoHundred.Ok)
  }

}
