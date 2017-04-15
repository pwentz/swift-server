import Responses

public protocol ResponseFormatter {
  func execute(on response: inout HTTPResponse)
}
