import Requests
import Responses

public class CoffeeController: Controller {
  public func process(_ request: Request) throws -> Response {
    var emptyHeaders: [String: String] = [:]

    return Response(status: 418,
                    headers: emptyHeaders,
                    body: "I'm a teapot")
  }
}
