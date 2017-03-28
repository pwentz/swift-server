import Requests
import Responses

class MethodOptionsController: Controller {
  public func process(_ request: Request) -> Response {
    let headers = ["Allow": "GET,HEAD,POST,OPTIONS,PUT"]

    return Response(status: 200,
                    headers: headers,
                    body: nil)
  }
}
