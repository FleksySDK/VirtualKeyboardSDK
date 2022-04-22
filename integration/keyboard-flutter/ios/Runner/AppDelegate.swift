import FleksySDK
import UIKit
import Flutter


@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        
        let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
        let channel = FlutterMethodChannel(name: "flutter.native/helper",
                                           binaryMessenger: controller.binaryMessenger)
        channel.setMethodCallHandler({
            (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
            
            
            
            print(call.method)
            switch(call.method) {
            case "isImeEnabled": result(self.isImeEnabled)
            case "isImeSelected": result(self.isImeSelected())
            case "enableIme": result(self.enableIme())
            default: print("")
            }
            
            
        })
        
        
        GeneratedPluginRegistrant.register(with: self)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    
    private func isImeSelected() -> Bool {
        return true
    }
    
    private var isImeEnabled: Bool {
        return FleksyExtensionSetupStatus.isAddedToSettingsKeyboardExtension(withBundleId: "co.thingthing.integration.flutter")
    }
    
    private func enableIme() -> Void {
        let url = URL(string: UIApplication.openSettingsURLString)!
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
}