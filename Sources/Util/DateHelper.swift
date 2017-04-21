import Foundation

public class DateHelper {
  private let today: Date
  private let calendar: Calendarizable
  private var formatter: DateFormattable

  public var rfcTimestamp: String {
    formatter.dateFormat = "E, d MMM yyyy HH:mm:ss Z"
    return formatter.string(from: today)
  }

  public init(today: Date, calendar: Calendarizable, formatter: DateFormattable) {
    self.today = today
    self.calendar = calendar
    self.formatter = formatter
  }

  public func formatTimestamp(prefix: String, dateSeparator: String = "-") -> String {
    let currentTime = time(separator: ":")
    let today = date(separator: dateSeparator)

    return "\(prefix)-\(currentTime)--\(today)"
  }

  private func time(separator: String) -> String {
    let hour = calendar.currentHour(from: today)
    let minutes = calendar.currentMinute(from: today)
    let seconds = calendar.currentSecond(from: today)

    return "\(hour)" + separator + "\(minutes)" + separator + "\(seconds)"
  }

  private func date(separator: String) -> String {
    formatter.dateFormat = "MM\(separator)dd\(separator)yyyy"

    return formatter.string(from: today)
  }

}
