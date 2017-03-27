import Requests
import Responses

public class FoobarController: Controller {

  public func process(_ request: Request) -> Response {
    return Response(status: 404,
                    headers: [:],
                    body: nil)
  }

}
