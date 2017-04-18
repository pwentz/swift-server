import Foundation
import Requests
import Responses

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
                              .flatMap{ String(bytes: $0, encoding: .utf8) }
                              .map { rangeOf($0, range: validRange) }?
                              .toData

    return HTTPResponse(
      status: TwoHundred.PartialContent,
      headers: response.headers,
      body: partialBody
    )
  }

  private func rangeOf(_ currentBody: String, range: String) -> String {
    let splitRange = range.components(separatedBy: "=")
    let rawRange = splitRange[splitRange.index(before: splitRange.endIndex)]

    let chars = Array(currentBody.characters).map { String($0) }

    let range = calculateRange(of: rawRange, length: currentBody.characters.count)

    return chars[range].joined(separator: "")
  }

  private func calculateRange(of rawRange: String, length contentLength: Int) -> Range<Int> {
    let splitRange = rawRange.components(separatedBy: "-")
    let rawStart = splitRange[splitRange.startIndex]
    let rawEnd = splitRange[splitRange.index(before: splitRange.endIndex)]

    let rangeEnd = Int(rawEnd) ?? contentLength - 1

    let rangeStart = Int(rawStart) ?? contentLength - rangeEnd

    return rangeEnd < rangeStart ? rangeStart..<contentLength
                                 : rangeStart..<rangeEnd + 1
  }
}
