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

    let formattedParams = [String: String](params: validParams)
                           .map { $0 + " = " + $1 }
                           .joined(separator: "\n")

    let newResponse = HTTPResponse(
      status: response.status,
      body: formattedParams
    )

    return response + newResponse
  }

}
