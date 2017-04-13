import PackageDescription

let package = Package(
    name: "Server",
    targets: [
      Target(name: "Server", dependencies: [
        .Target(name: "Router"),
        .Target(name: "Util"),
        .Target(name: "Errors"),
        .Target(name: "Shared"),
        .Target(name: "FileIO"),
        .Target(name: "Requests"),
        .Target(name: "Responses"),
        .Target(name: "Routes"),
        .Target(name: "Responders")
      ]),
      Target(name: "Controllers", dependencies: [
        .Target(name: "Util"),
        .Target(name: "Requests"),
        .Target(name: "Responses"),
        .Target(name: "Shared")
      ]),
      Target(name: "Responders", dependencies: [
        .Target(name: "Requests"),
        .Target(name: "Routes")
      ]),
      Target(name: "Router", dependencies: [
        .Target(name: "Controllers"),
        .Target(name: "Requests"),
        .Target(name: "Responses"),
        .Target(name: "Util"),
        .Target(name: "Shared"),
        .Target(name: "FileIO"),
        .Target(name: "Responders"),
        .Target(name: "Routes")
      ]),
      Target(name: "Util", dependencies: [
        .Target(name: "Errors"),
        .Target(name: "Shared")
      ]),
      Target(name: "FileIO", dependencies: [
        .Target(name: "Shared"),
        .Target(name: "Errors")
      ]),
      Target(name: "Routes", dependencies: [
        .Target(name: "Requests")
      ])
    ],
    dependencies: [
      .Package(url: "https://github.com/vapor/socks.git", majorVersion: 1, minor: 2)
    ]
)
