import Requests
import Responses

public class CoffeeController: Controller {

  public func process(_ request: Request) -> Response {
    return HTTPResponse(status: FourHundred.Teapot,
                        body: "I'm a teapot")
  }

}
