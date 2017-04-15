import Responses

extension HTTPResponse: Equatable {
  static public func == (lhs: HTTPResponse, rhs: HTTPResponse) -> Bool {
    switch (lhs, rhs) {
    default:
      return lhs.statusCode == rhs.statusCode &&
              lhs.headers == rhs.headers &&
                lhs.body ?? [] == rhs.body ?? []
    }
  }
}
