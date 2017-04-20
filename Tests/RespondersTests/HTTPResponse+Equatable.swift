import Responses

extension HTTPResponse: Equatable {
  static public func == (lhs: HTTPResponse, rhs: HTTPResponse) -> Bool {
    switch (lhs, rhs) {
    default:
      let leftHeaders = lhs.headers ?? [:]
      let rightHeaders = rhs.headers ?? [:]

      return lhs.statusCode == rhs.statusCode &&
              leftHeaders == rightHeaders &&
                lhs.body?.toBytes ?? [] == rhs.body?.toBytes ?? []
    }
  }
}
