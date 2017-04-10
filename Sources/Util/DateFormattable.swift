import Foundation

public protocol DateFormattable {
  var dateFormat: String! { get set }
  func string(from today: Date) -> String
}
