import Requests
import Responses

public class CoffeeController: Controller {

  public func process(_ request: Request) -> Response {
    let emptyHeaders: [String: String] = [:]
    let body: [UInt8]? = Array("I'm a teapot".utf8)

    return Response(status: 418,
                    headers: emptyHeaders,
                    body: body)
  }

}
