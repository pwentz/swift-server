import Requests
import Responses

public class DefaultController: Controller {

  public func process(_ request: Request) -> Response {
    return Response(status: 200,
                    headers: ["Content-Type": "text/html"],
                    body: "")
  }

}
