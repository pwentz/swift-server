import Foundation

public class Request {
  public let verb: String
  public let path: String
  public let params: Params?

  public let headers: [String: String]

  public init(for rawRequest: String) {
    let parsedRequest = rawRequest.components(separatedBy: "\r\n").filter { !$0.isEmpty }

    headers = parsedRequest.dropFirst().map { RequestHeader(for: $0) }.reduce([:]) {
       var mutable = $0
       mutable[$1.key] = $1.value
       return mutable
    }

    let mainHeader = parsedRequest.first ?? ""
    let mainHeaderParsed = mainHeader.components(separatedBy: " ")

    verb = mainHeaderParsed.first ?? ""

    let fullPath = mainHeaderParsed[mainHeaderParsed.index(after: mainHeaderParsed.startIndex)]

    let parsedPath = fullPath.components(separatedBy: "?")

    path = parsedPath.first ?? fullPath

    params = parsedPath.index(where: { $0.contains("=") }).map { _ in Params(for: fullPath) }
  }

}
