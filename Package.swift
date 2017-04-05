import PackageDescription

let package = Package(
    name: "Server",
    targets: [
      Target(name: "Server", dependencies: [
        .Target(name: "Router"),
        .Target(name: "Util"),
        .Target(name: "Errors"),
        .Target(name: "Shared"),
        .Target(name: "FileIO")
      ]),
      Target(name: "Controllers", dependencies: [
        .Target(name: "Util"),
        .Target(name: "Requests"),
        .Target(name: "Responses"),
        .Target(name: "Shared")
      ]),
      Target(name: "Router", dependencies: [
        .Target(name: "Controllers"),
        .Target(name: "Requests"),
        .Target(name: "Responses"),
        .Target(name: "Util"),
        .Target(name: "Shared"),
        .Target(name: "FileIO")
      ]),
      Target(name: "Util", dependencies: [
        .Target(name: "Errors"),
        .Target(name: "Shared")
      ])
    ],
    dependencies: [
      .Package(url: "https://github.com/vapor/socks.git", majorVersion: 1, minor: 2)
    ]
)
