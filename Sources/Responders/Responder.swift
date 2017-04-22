import Requests
import Responses

public protocol Responder {
  func response(to request: HTTPRequest) -> HTTPResponse
}
