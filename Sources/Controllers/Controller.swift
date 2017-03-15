import Requests
import Responses

public protocol Controller {
  static func process(_ request: Request) -> FormattedResponse
}
