import SwiftUI
import AppKit
import UserNotifications

@main
struct PhoneBackApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        Settings { EmptyView() }
    }
}

class AppDelegate: NSObject, NSApplicationDelegate, NSWindowDelegate, UNUserNotificationCenterDelegate {
    
    var statusItem: NSStatusItem?
    var activeWindows: [NSWindow] = []
    var inactivityTimer: Timer?
    var notificationTimer: Timer?
    var nonInteractedCount: Int = 0
    var flashTimers: [Timer] = []
    var secretInput: String = ""
    
    let notificationMessages = [
        "Give me my phone back!", "Stop taking my phone!", "Return my phone immediately",
        "I need my phone back right now", "You're not supposed to take me!", "Phone thief!",
        "This isn't funny anymore", "Give me back my phone!", "Stop hiding my phone!"
    ]
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        NSApp.setActivationPolicy(.accessory)
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, _ in
            if granted {
                UNUserNotificationCenter.current().delegate = self
            }
        }
        
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
        if let button = statusItem?.button {
            button.image = NSImage(systemSymbolName: "gearshape.fill", accessibilityDescription: nil)
        }
        
        startNotificationTimer()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.showNewWindow()
        }
    }
    
    func startNotificationTimer() {
        notificationTimer?.invalidate()
        notificationTimer = Timer.scheduledTimer(withTimeInterval: 50.0, repeats: true) { [weak self] _ in
            self?.sendRandomNotification()
        }
    }
    
    func sendRandomNotification() {
        let message = notificationMessages.randomElement() ?? "Give me my phone back!"
        let content = UNMutableNotificationContent()
        content.title = "PhoneBack"
        content.body = message
        content.sound = .default
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: nil)
        UNUserNotificationCenter.current().add(request)
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        DispatchQueue.main.async { [weak self] in
            self?.showNewWindow(isInteractionReset: true)
        }
        completionHandler()
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .sound])
    }
    
    @objc func showNewWindow(isInteractionReset: Bool = false) {
        // ... (I'll send the rest in the next message because it's very long)
        // For now, let's test if GitHub Actions can at least build a basic version
        print("New window requested")
    }
    
    // Add the rest of the functions later after we test build
}
