import Foundation
import Requests
import Responses
import Util

public class PartialFormatter: ResponseFormatter {
  let range: String?
  private let parsedRange: (start: Int?, end: Int?)

  public init(for range: String?) {
    self.range = range
    self.parsedRange = parseRangeHeader(range)
  }

  public func addToResponse(_ response: HTTPResponse) -> HTTPResponse {
    guard range != nil else {
      return response
    }

    let originalContent = response.body.flatMap(String.init)
    let contentLength = originalContent?.count
    let givenRange = contentLength.map(calculateRange)

    let newHeaders = givenRange.map { rnge -> [String: String] in
      let length: Any = contentLength ?? "*"
      return [
        "Content-Range": "bytes \(rnge.lowerBound)-\(rnge.upperBound - 1)/\(length)"
      ]
    }

    return HTTPResponse(
      status: TwoHundred.PartialContent,
      headers: newHeaders,
      body: givenRange.flatMap { range in
        originalContent.map(chars)?[range].joined(separator: "")
      }
    )
  }

  private func calculateRange(length contentLength: Int) -> Range<Int> {
    let rangeEnd = parsedRange.end ?? contentLength - 1

    let rangeStart = parsedRange.start ?? contentLength - rangeEnd

    return rangeEnd < rangeStart ? rangeStart..<contentLength
                                 : rangeStart..<rangeEnd + 1
  }

  private func chars(_ body: String) -> [String] {
    return body.characters.map { String($0) }
  }

}
