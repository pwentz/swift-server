import Requests
import Responses

public class FoobarController: Controller {

  public func process(_ request: Request) -> Response {
    return Response(status: FourHundred.NotFound,
                    headers: [:],
                    body: nil)
  }

}
