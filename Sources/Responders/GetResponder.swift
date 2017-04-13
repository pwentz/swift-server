import Foundation
import Util
import Routes
import Requests
import Responses

class GetResponder: RouteResponder {
  let responders: [RouteResponder]

  public init(responders: [RouteResponder]) {
    self.responders = responders
  }

  public func execute(on response: inout HTTPResponse) {
    responders.forEach { $0.execute(on: &response) }
  }

}
