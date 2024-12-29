import ProjectDescription

// MARK: - Version
let appVersion = "0.1.3"  // 应用版本号
let buildVersion = "@BUILD_NUMBER@"  // 构建版本号占位符，会被 GitHub Actions 替换

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
            "SWIFT_EMIT_LOC_STRINGS": "YES",
            "MARKETING_VERSION": SettingValue(stringLiteral: appVersion),
            "CURRENT_PROJECT_VERSION": SettingValue(stringLiteral: buildVersion)
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
                "AppleLanguages": ["zh-Hans"],  // 设置默认语言为简体中文
                "NSHumanReadableCopyright": "Copyright © 2024 ygsgdbd. All rights reserved.",
                "LSApplicationCategoryType": "public.app-category.utilities",
                "LSMinimumSystemVersion": "13.0",
                "CFBundleShortVersionString": .string(appVersion),  // 市场版本号
                "CFBundleVersion": .string(buildVersion)  // 构建版本号
            ]),
            sources: ["DanceKunKun/Sources/**"],
            resources: [
                "DanceKunKun/Resources/**",
                .folderReference(path: "DanceKunKun/Assets")
            ]
        )
    ]
)
