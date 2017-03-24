import Util
import Requests
import Responses

class ParametersController: Controller {

  public func process(_ request: Request) -> Response {

    let body = request.params.map { params in
      Array(
        params
         .toDictionary()
         .map { $0 + " = " + $1 }
         .joined(separator: "\n")
         .utf8
      )
    }

    return Response(status: 200,
                    headers: [:],
                    body: body)
  }

}
