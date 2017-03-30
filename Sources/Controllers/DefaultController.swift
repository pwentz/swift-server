import Requests
import Responses

public class DefaultController: Controller {

  public func process(_ request: Request) -> Response {
    return Response(status: TwoHundred.Ok,
                    headers: ["Content-Type": "text/html"],
                    body: nil)
  }

}
