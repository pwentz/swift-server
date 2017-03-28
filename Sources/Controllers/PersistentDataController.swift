import Requests

protocol PersistentDataController: Controller {
  static func update(_ request: Request)
}
