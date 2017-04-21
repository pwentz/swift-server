extension HTTPResponse: Equatable {

  static public func == (lhs: HTTPResponse, rhs: HTTPResponse) -> Bool {
    switch (lhs, rhs) {
    default:
      let leftHeaders = lhs.headers ?? [:]
      let rightHeaders = rhs.headers ?? [:]

      return lhs.status.description == rhs.status.description &&
              leftHeaders == rightHeaders &&
                lhs.body?.toBytes ?? [] == rhs.body?.toBytes ?? []
    }
  }

}
