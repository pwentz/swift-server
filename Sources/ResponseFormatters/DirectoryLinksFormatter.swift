import Requests
import Responses

public class DirectoryLinksFormatter: ResponseFormatter {
  let request: Request
  let files: [String]?

  public init(for request: Request, files: [String]?) {
    self.request = request
    self.files = files
  }

  public func execute(on response: inout HTTPResponse) {
    files.map { fileNames in
      let links = fileNames.map { "<a href=\"/\($0)\">\($0)</a>" }
      response.appendToBody(links.joined(separator: "<br>"))
    }
  }
}
