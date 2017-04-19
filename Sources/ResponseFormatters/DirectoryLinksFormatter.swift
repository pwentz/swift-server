import Foundation
import Responses

public class DirectoryLinksFormatter: ResponseFormatter {
  let files: [String]?

  public init(files: [String]?) {
    self.files = files
  }

  public func addToResponse(_ response: HTTPResponse) -> HTTPResponse {
    guard let fileNames = files else {
      return response
    }

    guard response.headers?["Content-Type"] != "text/plain" else {
      return response
    }

    let formattedLinks = fileNames.map(htmlLink)
                                  .joined(separator: "<br>")
                                  .toData

    return HTTPResponse(
      status: TwoHundred.Ok,
      headers: response.headers,
      body: response.updateBody(with: formattedLinks)
    )
  }

  private func trimSlash(in file: String) -> String {
    return file.substring(from: file.index(after: file.startIndex))
  }

  private func htmlLink(_ file: String) -> String {
    return "<a href=\"\(file)\">\(trimSlash(in: file))</a>"
  }

}
