import Requests
import Responses

class MethodOptionsController: Controller {

  public func process(_ request: Request) -> Response {
    let allowedVerbs = request.path.contains("2") ? "GET,OPTIONS"
                                                  : "GET,HEAD,POST,OPTIONS,PUT"

    return HTTPResponse(status: TwoHundred.Ok,
                        headers: ["Allow": allowedVerbs])
  }

}
