import Responses

public protocol RouteResponder {
  func execute(on response: inout HTTPResponse)
}
