import Requests
import Responses

public protocol Responder {
  func getResponse(to request: Request) -> Response
}
