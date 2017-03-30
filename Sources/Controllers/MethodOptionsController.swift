import Requests
import Responses

class MethodOptionsController: Controller {

  public func process(_ request: Request) -> Response {
    let allowedVerbs = request.path.contains("2") ? "GET,OPTIONS"
                                                  : "GET,HEAD,POST,OPTIONS,PUT"
    let headers = ["Allow": allowedVerbs]

    return Response(status: TwoHundred.Ok,
                    headers: headers,
                    body: nil)
  }

}
