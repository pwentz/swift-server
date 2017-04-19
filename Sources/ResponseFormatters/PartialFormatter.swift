import Foundation
import Requests
import Responses
import Util

public class PartialFormatter: ResponseFormatter {
  let range: String?

  public init(for range: String?) {
    self.range = range
  }

  public func addToResponse(_ response: HTTPResponse) -> HTTPResponse {
    guard let validRange = range else {
      return response
    }

    let partialBody = response.body
                              .flatMap { String(bytes: $0, encoding: .utf8) }
                              .map { rangeOf($0, range: validRange) }?
                              .toData

    return HTTPResponse(
      status: TwoHundred.PartialContent,
      headers: response.headers,
      body: partialBody
    )
  }

  private func rangeOf(_ currentBody: String, range: String) -> String {
    let chars = Array(currentBody.characters).map { String($0) }

    let range = calculateRange(length: currentBody.characters.count)

    return chars[range].joined(separator: "")
  }

  private func calculateRange(length contentLength: Int) -> Range<Int> {
    let parsedRange = parseRangeHeader(range)

    let rangeEnd = parsedRange.end ?? contentLength - 1

    let rangeStart = parsedRange.start  ?? contentLength - rangeEnd

    return rangeEnd < rangeStart ? rangeStart..<contentLength
                                 : rangeStart..<rangeEnd + 1
  }

}
