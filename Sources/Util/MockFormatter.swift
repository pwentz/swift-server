import Foundation

public class MockFormatter: DateFormattable {
  let month: String
  let day: String
  let year: String

  public var dateFormat: String! = "MM/dd/yyyy"

  public init(month: String, day: String, year: String) {
    self.month = month
    self.day = day
    self.year = year
  }

  public func string(from today: Date) -> String {
    let months = ["04": "Apr"]
    let separator = String(dateFormat.characters[dateFormat.index(dateFormat.startIndex, offsetBy: 2)])

    return dateFormat == "MM\(separator)dd\(separator)yyyy" ?
      month + separator + day + separator + year :
      "Fri, \(day) \(months[month]!) \(year)"
  }
}

