import Requests
import Responses

public protocol Respondable {
  func response(to request: HTTPRequest) -> HTTPResponse
}
