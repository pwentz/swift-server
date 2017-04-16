import Requests
import Responses

public class ParamsFormatter: ResponseFormatter {
  let request: HTTPRequest

  public init(for request: HTTPRequest) {
    self.request = request
  }

  public func execute(on response: inout HTTPResponse) {
    request.params.map { params in
      let formattedParams = params
                             .toDictionary()
                             .map { $0 + " = " + $1 }
                             .joined(separator: "\n")

      response.appendToBody(formattedParams)
    }
  }
}
