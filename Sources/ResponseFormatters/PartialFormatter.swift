import Foundation
import Requests
import Responses
import Util

public class PartialFormatter: ResponseFormatter {
  let givenRange: String?

  public init(for givenRange: String?) {
    self.givenRange = givenRange
  }

  public func addToResponse(_ response: HTTPResponse) -> HTTPResponse {
    let existingBody = response.body.flatMap(String.init)

    guard givenRange != nil, let defaultContent = existingBody else {
      return response
    }

    let fullLength = defaultContent.count
    let range = calculateRange(length: fullLength)

    let partialBody = defaultContent.chars[range].joined(separator: "")

    let newHeaders = [
      "Content-Range": "bytes \(range.lowerBound)-\(range.upperBound - 1)/\(fullLength)",
      "Content-Length": "\(partialBody.count)"
    ]

    return HTTPResponse(
      status: TwoHundred.PartialContent,
      headers: newHeaders,
      body: partialBody
    )
  }

  private func calculateRange(length contentLength: Int) -> Range<Int> {
    let parsedRange = parseRangeHeader(givenRange)
    let rangeEnd = parsedRange.end ?? contentLength - 1

    let rangeStart = parsedRange.start ?? contentLength - rangeEnd

    return rangeEnd < rangeStart ? rangeStart..<contentLength
                                 : rangeStart..<rangeEnd + 1
  }

}
