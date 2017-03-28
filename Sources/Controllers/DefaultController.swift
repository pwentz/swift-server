import Requests
import Responses

public class DefaultController: Controller {

  public static func process(_ request: Request) -> HTTPResponse {
    return EmptyResponse(status: 200)
  }

}
