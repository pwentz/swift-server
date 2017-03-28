import Requests
import Responses

class MethodOptionsController: Controller {

  public static func process(_ request: Request) -> HTTPResponse {
    let allowedVerbs = request.path.contains("2") ? "GET,OPTIONS"
                                                  : "GET,HEAD,POST,OPTIONS,PUT"
    let headers = ["Allow": allowedVerbs]

    return Response(status: 200,
                    headers: headers,
                    body: nil)
  }

}
