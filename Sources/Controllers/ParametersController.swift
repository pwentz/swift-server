import Util
import Requests
import Responses

class ParametersController: Controller {

  public static func process(_ request: Request) -> HTTPResponse {

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
