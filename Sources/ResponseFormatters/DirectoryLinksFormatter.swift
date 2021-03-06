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

    let formattedLinks = fileNames
                          .map(htmlLink)
                          .joined(separator: "<br>")

    let newResponse = HTTPResponse(
      status: response.status,
      body: formattedLinks
    )

    return response + newResponse
  }

  private func trimSlash(in file: String) -> String {
    return String(file.characters.dropFirst())
  }

  private func htmlLink(_ file: String) -> String {
    return "<a href=\"\(file)\">\(trimSlash(in: file))</a>"
  }

}
