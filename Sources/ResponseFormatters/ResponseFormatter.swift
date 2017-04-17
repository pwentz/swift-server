import Responses

public protocol ResponseFormatter {
  func addToResponse(_ response: HTTPResponse) -> HTTPResponse
}
