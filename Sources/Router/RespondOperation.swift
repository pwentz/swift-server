import Requests
import Controllers
import Responses
import Foundation
import Util

class RespondOperation: Operation {
  override var isAsynchronous: Bool {
    return true
  }

  override var isConcurrent: Bool {
    return true
  }

  override var isExecuting: Bool {
    return currentlyExecuting
  }

  override var isFinished: Bool {
    return currentlyFinished
  }

  var currentlyExecuting: Bool = false
  var currentlyFinished: Bool = false

  let response: Response
  let client: Socket

  init(response: Response, client: Socket) {
    self.response = response
    self.client = client
  }

  override func start() {
    do {
      currentlyExecuting = true

      try client.send(data: response.formatted)

      currentlyFinished = true
      currentlyExecuting = false

      try client.close()
    } catch {}
  }

}
