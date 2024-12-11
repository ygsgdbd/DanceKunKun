import SwiftUI
import CoreText
import Combine

@main
struct DanceKunKunApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    init() {
        CustomFont.register()
    }
    
    var body: some Scene {
        Settings {
            EmptyView()
        }
    }
}

@MainActor
class AppDelegate: NSObject, NSApplicationDelegate {
    private var statusItem: NSStatusItem?
    private let animationController = FontAnimationController()
    private let fontSize: CGFloat = 16
    private var notificationObserver: Any?
    private var cancellables = Set<AnyCancellable>()
    
    deinit {
        // 清理通知观察者
        if let observer = notificationObserver {
            DistributedNotificationCenter.default().removeObserver(observer)
        }
        
        // 清理状态栏项
        statusItem = nil
    }
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        // 注册字体
        registerFont()
        
        // 设置状态栏
        setupStatusBarItem()
        
        // 监听系统主题变化
        setupAppearanceObserver()
        
        // 监听字体变化
        animationController.$currentGlyph
            .sink { [weak self] glyph in
                self?.updateStatusBarGlyph(with: glyph)
            }
            .store(in: &cancellables)
        
        // 初始化外观
        updateAppearance()
    }
    
    private func registerFont() {
        guard let fontURL = Bundle.main.url(forResource: "Zhiyin", withExtension: "otf") else {
            NSLog("Failed to find Zhiyin.otf")
            return
        }
        
        var error: Unmanaged<CFError>?
        if !CTFontManagerRegisterFontsForURL(fontURL as CFURL, .process, &error) {
            if let error = error?.takeRetainedValue() {
                NSLog("Failed to register font: \(error)")
            }
        }
    }
    
    @MainActor
    private func setupStatusBarItem() {
        statusItem = NSStatusBar.system.statusItem(withLength: 18)
        
        guard let button = statusItem?.button else {
            NSLog("Failed to create status bar button")
            return
        }
        
        let font = NSFont(name: "Zhiyin", size: fontSize) ?? .systemFont(ofSize: fontSize)
        button.font = font
        button.cell?.alignment = .center
        button.cell?.lineBreakMode = .byClipping
        button.target = self
        button.action = #selector(statusItemClicked)
        button.toolTip = "DanceKunKun"
        
        // 初始化显示第一个字形
        updateStatusBarGlyph(with: animationController.currentGlyph)
    }
    
    private func setupAppearanceObserver() {
        notificationObserver = NSApp.observe(\.effectiveAppearance) { [weak self] _, _ in
            Task { @MainActor [weak self] in
                self?.updateAppearance()
            }
        }
    }
    
    @MainActor
    private func updateAppearance() {
        guard let button = statusItem?.button else { return }
        
        let text = button.title
        let attributes: [NSAttributedString.Key: Any] = [
            .font: button.font ?? .systemFont(ofSize: fontSize),
            .foregroundColor: NSColor.labelColor
        ]
        
        button.attributedTitle = NSAttributedString(string: text, attributes: attributes)
    }
    
    @MainActor
    private func updateStatusBarGlyph(with glyph: String?) {
        guard let glyph = glyph else { return }
        statusItem?.button?.title = glyph
    }
    
    @objc private func statusItemClicked() {
        statusItem?.menu = animationController.buildMenu()
    }
}
