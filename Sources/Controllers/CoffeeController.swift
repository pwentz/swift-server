import Requests
import Responses

public class CoffeeController: Controller {

  public func process(_ request: Request) -> Response {
    return Response(status: FourHundred.Teapot,
                    headers: [:],
                    body: Array("I'm a teapot".utf8))
  }

}
