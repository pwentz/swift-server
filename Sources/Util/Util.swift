import Foundation

public func getBase64(of input: String) -> String {
  let data = input.data(using: String.Encoding.utf8)
  return data!.base64EncodedString(options: Data.Base64EncodingOptions(rawValue: 0))
}

public func separate(_ input: String, by separator: Character) -> [String] {
  return input.characters.split { $0 == separator }.map(String.init)
}
