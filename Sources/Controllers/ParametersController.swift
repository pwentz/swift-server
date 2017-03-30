import Util
import Requests
import Responses

class ParametersController: Controller {

  public func process(_ request: Request) -> Response {

    let body = request.params.map { params in
      params
       .toDictionary()
       .map { $0 + " = " + $1 }
       .joined(separator: "\n")
    }

    return HTTPResponse(status: TwoHundred.Ok,
                        body: body)
  }

}
