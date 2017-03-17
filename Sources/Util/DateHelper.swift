import Foundation

public class DateHelper {
  private let today = Date()
  private let calendar = Calendar.current
  private let formatter = DateFormatter()

  public init() {}

  public func time(separator: String) -> String {
    let hour = calendar.component(.hour, from: today)
    let minutes = calendar.component(.minute, from: today)
    let seconds = calendar.component(.second, from: today)

    return "\(hour)" + separator + "\(minutes)" + separator + "\(seconds)"
  }

  public func date(separator: String) -> String {
    formatter.dateFormat = "MM\(separator)dd\(separator)yyyy"

    return formatter.string(from: today)
  }
}
