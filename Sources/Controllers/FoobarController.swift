import Requests
import Responses

public class FoobarController: Controller {

  public func process(_ request: Request) -> Response {
    return HTTPResponse(status: FourHundred.NotFound)
  }

}
