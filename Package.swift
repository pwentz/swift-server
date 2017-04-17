import PackageDescription

let package = Package(
    name: "Server",
    targets: [
      Target(name: "Server", dependencies: [
        .Target(name: "Router"),
        .Target(name: "Util"),
        .Target(name: "Config"),
        .Target(name: "FileIO"),
        .Target(name: "Routes"),
        .Target(name: "Responders")
      ]),
      Target(name: "Config", dependencies: [
        .Target(name: "Routes"),
        .Target(name: "Responses")
      ]),
      Target(name: "Responders", dependencies: [
        .Target(name: "Requests"),
        .Target(name: "Routes"),
        .Target(name: "Responses"),
        .Target(name: "ResponseFormatters"),
        .Target(name: "Util")
      ]),
      Target(name: "ResponseFormatters", dependencies: [
        .Target(name: "Requests"),
        .Target(name: "Routes"),
        .Target(name: "Responses")
      ]),
      Target(name: "Router", dependencies: [
        .Target(name: "Requests"),
        .Target(name: "Responses"),
        .Target(name: "Responders")
      ]),
      Target(name: "Util", dependencies: [
        .Target(name: "Errors"),
        .Target(name: "Responses")
      ]),
      Target(name: "FileIO", dependencies: [
        .Target(name: "Config"),
        .Target(name: "Errors")
      ]),
      Target(name: "Routes", dependencies: [
        .Target(name: "Requests"),
        .Target(name: "Responses")
      ])
    ],
    dependencies: [
      .Package(url: "https://github.com/vapor/socks.git", majorVersion: 1, minor: 2)
    ]
)
