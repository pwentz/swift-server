import Responses

public class DirectoryLinksFormatter: ResponseFormatter {
  let files: [String]?

  public init(files: [String]?) {
    self.files = files
  }

  public func execute(on response: inout HTTPResponse) {
    guard let fileNames = files else {
      return
    }

    let links = fileNames.map { "<a href=\"\($0)\">\(trimSlash(in: $0))</a>" }
    response.appendToBody(links.joined(separator: "<br>"))
  }

  private func trimSlash(in file: String) -> String {
    return file.substring(from: file.index(after: file.startIndex))
  }
}
