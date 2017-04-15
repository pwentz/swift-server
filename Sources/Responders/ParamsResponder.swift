import Requests
import Responses

class ParamsResponder: ResponseFormatter {
  let request: Request

  public init(for request: Request) {
    self.request = request
  }

  func execute(on response: inout HTTPResponse) {
    request.params.map { params in
      let formattedParams = params
                             .toDictionary()
                             .map { $0 + " = " + $1 }
                             .joined(separator: "\n")

      response.appendToBody(formattedParams)
    }
  }
}
