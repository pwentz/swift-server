import Requests
import Responses

public class ParamsFormatter: ResponseFormatter {
  let params: HTTPParameters?

  public init(for params: HTTPParameters?) {
    self.params = params
  }

  public func execute(on response: inout HTTPResponse) {
    guard let validParams = params else {
      return
    }

    let formattedParams = validParams
                           .toDictionary()
                           .map { $0 + " = " + $1 }
                           .joined(separator: "\n")

    response.appendToBody(formattedParams)
  }
}
