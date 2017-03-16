import PackageDescription

let package = Package(
    name: "Server",
    targets: [
      Target(name: "FileHelpers"),
      Target(name: "Server", dependencies: [
        .Target(name: "Router"),
        .Target(name: "FileHelpers")
      ]),
      Target(name: "Requests"),
      Target(name: "Responses"),
      Target(name: "Controllers", dependencies: [
        .Target(name: "Util"),
        .Target(name: "Requests"),
        .Target(name: "Responses")
      ]),
      Target(name: "Router", dependencies: [
        .Target(name: "Controllers"),
        .Target(name: "Requests"),
        .Target(name: "Responses")
      ])
    ],
    dependencies: [
      .Package(url: "https://github.com/vapor/vapor.git", majorVersion: 1, minor: 1)
    ]
)
