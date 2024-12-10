import Foundation
import Darwin
import Combine
import SwiftUI
import AppKit

@MainActor
class SystemMonitor: ObservableObject {
    static let shared = SystemMonitor()
    @Published private(set) var cpuUsage: Double = 0.0
    
    // 使用常量避免重复创建
    private let updateInterval: TimeInterval = 2.0
    private let timerTolerance: TimeInterval = 0.1
    private let hostPort = mach_host_self()
    
    private var timer: Timer? {
        willSet {
            timer?.invalidate()
        }
    }
    private var previousCPUInfo: host_cpu_load_info?
    private var isMenuMonitoring = false
    
    private init() {
        startMonitoring()
    }
    
    func startMonitoring() {
        stopMonitoring()
        isMenuMonitoring = false
        setupTimer()
    }
    
    func startMenuMonitoring() {
        stopMonitoring()
        isMenuMonitoring = true
        setupTimer()
    }
    
    private func setupTimer() {
        // 在主线程上创建定时器并添加到当前 RunLoop
        let timer = Timer(timeInterval: updateInterval, 
                         target: self, 
                         selector: #selector(timerFired), 
                         userInfo: nil, 
                         repeats: true)
        timer.tolerance = timerTolerance
        
        RunLoop.main.add(timer, forMode: isMenuMonitoring ? .common : .default)
        self.timer = timer
        
        // 立即执行一次更新
        Task { await updateCPUUsage() }
    }
    
    private func stopMonitoring() {
        timer = nil
    }
    
    @objc private func timerFired() {
        Task { await updateCPUUsage() }
    }
    
    func updateCPUUsage() async {
        var cpuInfo = host_cpu_load_info()
        var count = mach_msg_type_number_t(MemoryLayout<host_cpu_load_info>.size / MemoryLayout<integer_t>.size)
        
        let result = withUnsafeMutablePointer(to: &cpuInfo) { ptr in
            ptr.withMemoryRebound(to: integer_t.self, capacity: Int(count)) { ptr in
                host_statistics(hostPort,
                              HOST_CPU_LOAD_INFO,
                              ptr,
                              &count)
            }
        }
        
        guard result == KERN_SUCCESS else { return }
        
        if let previousInfo = previousCPUInfo {
            let user = Double(cpuInfo.cpu_ticks.0 - previousInfo.cpu_ticks.0)
            let system = Double(cpuInfo.cpu_ticks.1 - previousInfo.cpu_ticks.1)
            let idle = Double(cpuInfo.cpu_ticks.2 - previousInfo.cpu_ticks.2)
            let nice = Double(cpuInfo.cpu_ticks.3 - previousInfo.cpu_ticks.3)
            
            let total = user + system + idle + nice
            if total > 0 {
                let usage = ((user + system + nice) / total) * 100.0
                let newUsage = min(100.0, max(0.0, usage))
                if abs(newUsage - cpuUsage) > 0.1 { // 只在变化超过 0.1% 时更新
                    self.cpuUsage = newUsage
                }
            }
        }
        previousCPUInfo = cpuInfo
    }
    
    deinit {
        timer = nil  // 属性观察器会自动调用 invalidate
    }
} 