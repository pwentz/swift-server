import Requests
import Responses

public class FoobarController: Controller {

  public static func process(_ request: Request) -> HTTPResponse {
    return EmptyResponse(status: 404)
  }

}
