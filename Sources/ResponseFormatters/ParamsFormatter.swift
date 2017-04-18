import Requests
import Responses

public class ParamsFormatter: ResponseFormatter {
  let params: HTTPParameters?

  public init(for params: HTTPParameters?) {
    self.params = params
  }

  public func addToResponse(_ response: HTTPResponse) -> HTTPResponse {
    guard let validParams = params else {
      return response
    }

    let formattedParams = validParams
                           .toDictionary()
                           .map { $0 + " = " + $1 }
                           .joined(separator: "\n")
                           .toData

    return HTTPResponse(
      status: TwoHundred.Ok,
      headers: response.headers,
      body: response.updateBody(with: formattedParams)
    )
  }

}
