import Foundation
import Util

public class Request {
  public let verb: String
  public let path: String
  public let params: [String: String]?

  public var headers: [String: String] = [:]

  public init(for rawRequest: String) {
    // Request will break if passed a string without a verb + path
    // use null object pattern for invalid request at higher level
    let parsedRequest = separate(rawRequest, by: "\r\n")
    let requestHeaders = parsedRequest[parsedRequest.index(after: parsedRequest.startIndex)..<parsedRequest.endIndex]
                                      .map { RequestHeader(for: $0) }

    for header in requestHeaders {
      headers[header.key] = header.value
    }

    let mainHeader = parsedRequest.first!
    let mainHeaderParsed = separate(mainHeader, by: " ")
    verb = mainHeaderParsed[0]
    // breaks here

    if mainHeaderParsed[1].contains("?") {
      let rawParams = separate(mainHeaderParsed[1], by: "?").last!
      path = separate(mainHeaderParsed[1], by: "?").first!
      let splitParams = separate(rawParams, by: "=")
      let paramsKey = splitParams.first!
      let paramsVal = splitParams.last!

      if paramsKey != paramsVal {
        params = [paramsKey: paramsVal]
      }
      else {
        params = nil
      }

    }
    else {
      path = mainHeaderParsed[1]
      params = nil
    }
  }
}
