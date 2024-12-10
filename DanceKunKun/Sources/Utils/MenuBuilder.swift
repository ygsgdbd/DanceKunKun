import Foundation
import AppKit
import Combine

@MainActor
class MenuBuilder: NSObject {
    static let shared = MenuBuilder()
    private var menuItem: NSMenuItem?
    private var menu: NSMenu?
    private var cancellables = Set<AnyCancellable>()
    
    // 使用常量避免重复创建
    private let cpuFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 1
        formatter.maximumFractionDigits = 1
        return formatter
    }()
    
    private override init() {
        super.init()
        
        // 监听 CPU 使用率变化，使用防抖动
        SystemMonitor.shared.$cpuUsage
            .debounce(for: .milliseconds(100), scheduler: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.updateMenuItem()
            }
            .store(in: &cancellables)
    }
    
    func updateMenuItem() {
        guard let menuItem = menuItem else { return }
        menuItem.title = String(format: "CPU: %.1f%%", SystemMonitor.shared.cpuUsage)
    }
    
    func buildMenu() -> NSMenu {
        // 如果已经有菜单，直接返回
        if let existingMenu = menu {
            return existingMenu
        }
        
        let newMenu = NSMenu()
        newMenu.autoenablesItems = true
        
        // 创建 CPU 使用率菜单项
        let cpuItem = NSMenuItem(title: String(format: "CPU: %.1f%%", 0.0), 
                                action: nil, 
                                keyEquivalent: "")
        cpuItem.isEnabled = false
        
        // 保存引用以便后续更新
        self.menuItem = cpuItem
        self.menu = newMenu
        
        // 添加菜单项
        newMenu.items = [
            cpuItem,
            .separator(),
            NSMenuItem(title: NSLocalizedString("Exit", comment: "Exit menu item"), 
                      action: #selector(NSApplication.terminate(_:)), 
                      keyEquivalent: "q")
        ]
        
        // 设置菜单代理
        newMenu.delegate = MenuDelegate.shared
        
        return newMenu
    }
    
    deinit {
        cancellables.removeAll()
    }
}

// 菜单代理，用于处理菜单打开和关闭事件
final class MenuDelegate: NSObject, NSMenuDelegate {
    static let shared = MenuDelegate()
    
    func menuWillOpen(_ menu: NSMenu) {
        SystemMonitor.shared.startMenuMonitoring()
    }
    
    func menuDidClose(_ menu: NSMenu) {
        SystemMonitor.shared.startMonitoring()
    }
} 