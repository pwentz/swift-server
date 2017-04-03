public protocol Request {
  var verb: HTTPRequestMethod { get }
  var path: String { get }
  var pathName: String { get }
  var params: Params? { get }
  var body: String? { get }
  var crlf: String { get }
  var headers: [String: String] { get }
  var headerDivide: String { get }
}
