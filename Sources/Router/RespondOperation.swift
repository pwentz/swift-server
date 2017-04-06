import Requests
import Controllers
import Responses
import Foundation
import Util

public class RespondOperation: Operation {
  public override var isAsynchronous: Bool {
    return true
  }

  public override var isConcurrent: Bool {
    return true
  }

  public override var isExecuting: Bool {
    return currentlyExecuting
  }

  public override var isFinished: Bool {
    return currentlyFinished
  }

  private var currentlyExecuting: Bool = false
  private var currentlyFinished: Bool = false

  private let response: Response
  private let client: Socket

  public init(response: Response, client: Socket) {
    self.response = response
    self.client = client
  }

  public override func start() {
    do {
      currentlyExecuting = true

      try client.send(data: response.formatted)

      currentlyFinished = true
      currentlyExecuting = false

      try client.close()
    } catch {}
  }

}
