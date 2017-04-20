public extension Dictionary where Key == String, Value == String {
  init(params: HTTPParameters) {
    self = [:]

    zip(params.keys, params.values).forEach { self[$0] = $1 }
  }
}
