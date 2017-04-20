import Util
import Foundation

public class MockFormatter: DateFormattable {
  let month: String
  let day: String
  let year: String

  public var dateFormat: String! = "mm/dd/yyyy"

  public init(month: String, day: String, year: String) {
    self.month = month
    self.day = day
    self.year = year
  }

  public func string(from today: Date) -> String {
    return "\(month)/\(day)/\(year)"
  }
}

