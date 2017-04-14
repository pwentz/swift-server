import Foundation
import Requests
import Responses

class PartialResponder: RouteResponder {
  let request: Request

  public init(for request: Request) {
    self.request = request
  }

  public func execute(on response: inout HTTPResponse) {
    request.headers["range"].map { range in
      let partialContent = response.body
                                   .flatMap(toString)
                                   .map { rangeOf("\($0)\n", range: range) }

      response.updateStatus(with: TwoHundred.PartialContent)
      response.replaceBody(with: partialContent ?? "")
    }
  }

  private func rangeOf(_ currentBody: String, range: String) -> String {
    let splitRange = range.components(separatedBy: "=")
    let rawRange = splitRange[splitRange.index(before: splitRange.endIndex)]

    let chars = Array(currentBody.characters).map { String($0) }

    let range = calculateRange(of: rawRange, length: currentBody.characters.count)

    return chars[range].joined(separator: "")
  }

  private func toString(_ body: [UInt8]) -> String? {
    return String(bytes: body, encoding: .utf8)?.trimmingCharacters(in: .newlines)
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
