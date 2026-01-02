import Cocoa
import FlutterMacOS

@main
class AppDelegate: FlutterAppDelegate {
  override func applicationDidFinishLaunching(_ notification: Notification) {
      let controller: FlutterViewController = mainFlutterWindow?.contentViewController as! FlutterViewController
      let nativeChannel = FlutterMethodChannel(name: "com.example.duplicateFileFinder/native",
                                                binaryMessenger: controller.engine.binaryMessenger)
      
      nativeChannel.setMethodCallHandler({
        (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
        if call.method == "moveToTrash" {
            guard let filePath = call.arguments as? String else {
                result(FlutterError(code: "INVALID_ARGUMENT", message: "File path must be a string", details: nil))
                return
            }
            self.moveToTrash(filePath: filePath, result: result)
        } else {
            result(FlutterMethodNotImplemented)
        }
      })
      
      super.applicationDidFinishLaunching(notification)
  }
    
  private func moveToTrash(filePath: String, result: @escaping FlutterResult) {
      let fileURL = URL(fileURLWithPath: filePath)
      do {
          try FileManager.default.trashItem(at: fileURL, resultingItemURL: nil)
          result(true)
      } catch {
          result(FlutterError(code: "TRASH_ERROR", message: error.localizedDescription, details: nil))
      }
  }

  override func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
    return true
  }

  override func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
    return true
  }
}