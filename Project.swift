import ProjectDescription

let project = Project(
    name: "DanceKunKun",
    options: .options(
        defaultKnownRegions: ["zh-Hans", "zh-Hant", "en"],
        developmentRegion: "zh-Hans"
    ),
    settings: .settings(
        base: [
            "SWIFT_VERSION": "5.9",
            "DEVELOPMENT_LANGUAGE": "zh-Hans",
            "SWIFT_EMIT_LOC_STRINGS": "YES"
        ],
        configurations: [
            .debug(name: "Debug"),
            .release(name: "Release")
        ]
    ),
    targets: [
        .target(
            name: "DanceKunKun",
            destinations: .macOS,
            product: .app,
            bundleId: "top.ygsgdbd.DanceKunKun",
            deploymentTargets: .macOS("13.0"),
            infoPlist: .extendingDefault(with: [
                "LSUIElement": true,  // 设置为纯菜单栏应用
                "CFBundleDevelopmentRegion": "zh-Hans",  // 设置默认开发区域为简体中文
                "CFBundleLocalizations": ["zh-Hans", "zh-Hant", "en"],  // 支持的语言列表
                "AppleLanguages": ["zh-Hans"]  // 设置默认���言为简体中文
            ]),
            sources: ["DanceKunKun/Sources/**"],
            resources: [
                "DanceKunKun/Resources/**",
                .folderReference(path: "DanceKunKun/Resources/zh-Hans.lproj"),
                .folderReference(path: "DanceKunKun/Resources/zh-Hant.lproj"),
                .folderReference(path: "DanceKunKun/Resources/en.lproj")
            ]
        )
    ]
)
