import Requests
import Responses

public class CookieResponder {
  let request: Request

  public init(for request: Request) {
    self.request = request
  }

  public func formatResponse(_ currentResponse: Response) -> Response {
    var newResponse = currentResponse

    if let params = request.params {
      String(parameters: params).map { newResponse.appendToHeaders(with: ["Set-Cookie": $0]) }
      newResponse.appendToBody("Eat")
    }
    else {
      newResponse.updateStatus(with: FourHundred.BadRequest)
    }

    return newResponse
  }
}
