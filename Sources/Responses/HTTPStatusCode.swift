public protocol HTTPStatusCode {
  var description: String { get }
}

public enum TwoHundred: HTTPStatusCode {
  case Ok, NoContent, PartialContent, Created

  public var description: String {
    switch self {
      case .Ok: return "200 OK"
      case .NoContent: return "204 No Content"
      case .PartialContent: return "206 Partial Content"
      case .Created: return "201 Created"
    }
  }
}

public enum ThreeHundred: HTTPStatusCode {
  case Found

  public var description: String {
    switch self {
      case .Found: return "302 Found"
    }
  }
}

public enum FourHundred: HTTPStatusCode {
  case Unauthorized, NotFound, MethodNotAllowed, Teapot

  public var description: String {
    switch self {
      case .Unauthorized: return "401 Unauthorized"
      case .NotFound: return "404 Not Found"
      case .MethodNotAllowed: return "405 Method Not Allowed"
      case .Teapot: return "418 I\'m a teapot"
    }
  }
}
