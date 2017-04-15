public protocol StatusCode {
  var description: String { get }
}

public enum TwoHundred: StatusCode {
  case Ok, NoContent, PartialContent

  public var description: String {
    switch self {
      case .Ok: return "200 OK"
      case .NoContent: return "204 No Content"
      case .PartialContent: return "206 Partial Content"
    }
  }
}

public enum ThreeHundred: StatusCode {
  case Found

  public var description: String {
    switch self {
      case .Found: return "302 Found"
    }
  }
}

public enum FourHundred: StatusCode {
  case Unauthorized, NotFound, MethodNotAllowed, Teapot, BadRequest

  public var description: String {
    switch self {
      case .Unauthorized: return "401 Unauthorized"
      case .NotFound: return "404 Not Found"
      case .MethodNotAllowed: return "405 Method Not Allowed"
      case .Teapot: return "418 I\'m a teapot"
      case .BadRequest: return "400 Bad Request"
    }
  }
}
