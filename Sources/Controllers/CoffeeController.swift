import Requests
import Responses

public class CoffeeController: Controller {

  public static func process(_ request: Request) -> HTTPResponse {
    return Response(status: 418,
                    headers: [:],
                    body: Array("I'm a teapot".utf8))
  }

}
