import Requests
import Responses

public protocol Controller {
  func process(_ request: Request) -> Response
}
