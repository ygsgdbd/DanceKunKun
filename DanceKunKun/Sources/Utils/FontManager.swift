import SwiftUI
import CoreText
import Combine

enum CustomFont {
    static let fontName = "Zhiyin"
    
    static func register() {
        print("✅ Scanning font characters...")
        if let fontURL = Bundle.main.url(forResource: "Zhiyin", withExtension: "otf"),
           let fontDataProvider = CGDataProvider(url: fontURL as CFURL),
           let cgFont = CGFont(fontDataProvider),
           let postScriptName = cgFont.postScriptName as String? {
            
            print("✅ Font PostScript name: \(postScriptName)")
            
            var error: Unmanaged<CFError>?
            guard CTFontManagerRegisterGraphicsFont(cgFont, &error) else {
                if let error = error?.takeRetainedValue() {
                    print("⚠️ Error registering font: \(error)")
                }
                return
            }
            
            let font = CTFontCreateWithName(postScriptName as CFString, 16, nil)
            let characterSet = CTFontCopyCharacterSet(font) as CharacterSet
            var glyphsArray: [String] = []
            
            // 遍历指定的 Unicode 点范围 (U+E900 ~ U+E910)
            for unicode in stride(from: 0xE900, through: 0xE910, by: 1) {
                if let scalar = UnicodeScalar(unicode),
                   characterSet.contains(scalar) {
                    glyphsArray.append(String(scalar))
                    print("Found glyph: \(String(scalar)) [Unicode: \(String(format: "U+%04X", unicode))]")
                }
            }
            
            glyphsArray.sort()
            print("✅ Found \(glyphsArray.count) valid characters in font")
            Self.glyphs = glyphsArray
        } else {
            print("⚠️ Failed to load font file or create font")
        }
    }
    
    static func custom(size: CGFloat) -> Font {
        .custom(fontName, size: size)
    }
    
    static private(set) var glyphs: [String] = []
    
    static func getAllGlyphs() -> [String] {
        return glyphs
    }
}

@MainActor
class FontAnimationController: ObservableObject {
    @Published private(set) var currentGlyph: String = "?"
    private let glyphs: [String]
    private let baseAnimationDuration: TimeInterval = 0.08
    private var currentAnimationDuration: TimeInterval
    private var currentGlyphIndex = 0
    private var animationTask: Task<Void, Never>?
    private var isAnimating = false
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        self.glyphs = CustomFont.getAllGlyphs()
        self.currentAnimationDuration = baseAnimationDuration
        print("✅ Animation initialized with \(glyphs.count) glyphs")
        if !glyphs.isEmpty {
            currentGlyph = glyphs[0]
        }
        
        // 直接观察 SystemMonitor 的 cpuUsage
        SystemMonitor.shared.$cpuUsage
            .throttle(for: .milliseconds(100), scheduler: DispatchQueue.main, latest: true)
            .sink { [weak self] cpuUsage in
                self?.updateAnimationSpeed(cpuUsage: cpuUsage)
            }
            .store(in: &cancellables)
        
        startAnimation()
    }
    
    private func updateAnimationSpeed(cpuUsage: Double) {
        // 使用指数函数使速度变化更加明显
        let normalizedCPU = cpuUsage / 100.0
        let exponentialFactor = 2.0
        let progress = pow(normalizedCPU, exponentialFactor)
        
        // 计算速度倍率
        let speedMultiplier = Constants.Animation.minSpeed + 
            (Constants.Animation.maxSpeed - Constants.Animation.minSpeed) * progress
        
        // 更新动画持续时间
        currentAnimationDuration = baseAnimationDuration / speedMultiplier
        
        print("CPU: \(String(format: "%.1f%%", cpuUsage)), Speed: \(String(format: "%.1fx", speedMultiplier))")
    }
    
    func startAnimation() {
        guard !isAnimating else { return }
        isAnimating = true
        
        animationTask = Task { [weak self] in
            guard let self = self, !self.glyphs.isEmpty else { return }
            
            while !Task.isCancelled && self.isAnimating {
                self.currentGlyphIndex = (self.currentGlyphIndex + 1) % self.glyphs.count
                self.currentGlyph = self.glyphs[self.currentGlyphIndex]
                try? await Task.sleep(nanoseconds: UInt64(self.currentAnimationDuration * 1_000_000_000))
            }
        }
    }
    
    func buildMenu() -> NSMenu {
        return MenuBuilder.shared.buildMenu()
    }
} 