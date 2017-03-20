import Requests
import Responses

public class FoobarController: Controller {
  public func process(_ request: Request) throws -> Response {
    var emptyHeaders: [String: String] = [:]

    return Response(status: 404,
                    headers: emptyHeaders,
                    body: "")
  }
}
