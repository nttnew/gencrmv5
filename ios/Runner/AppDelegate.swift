import UIKit
import Flutter
import flutter_local_notifications
import PushKit
import flutter_callkit_incoming_timer

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate, PKPushRegistryDelegate {
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        if #available(iOS 10.0, *) {
          UNUserNotificationCenter.current().delegate = self as UNUserNotificationCenterDelegate
        }

        GeneratedPluginRegistrant.register(with: self)

        //Setup VOIP
        let mainQueue = DispatchQueue.main
        let voipRegistry: PKPushRegistry = PKPushRegistry(queue: mainQueue)
        voipRegistry.delegate = self
        voipRegistry.desiredPushTypes = [PKPushType.voIP]

        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }

    // Call back from Recent history
    override func application(_ application: UIApplication,
                              continue userActivity: NSUserActivity,
                              restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {

        guard let handleObj = userActivity.handle else {
            return false
        }

        guard let isVideo = userActivity.isVideo else {
            return false
        }
        let nameCaller = handleObj.getDecryptHandle()["nameCaller"] as? String ?? ""
        let handle = handleObj.getDecryptHandle()["handle"] as? String ?? ""
        let data = flutter_callkit_incoming_timer.Data(id: UUID().uuidString, nameCaller: nameCaller, handle: handle, type: isVideo ? 1 : 0)
        //set more data...
        data.nameCaller = "Johnny"
        SwiftFlutterCallkitIncomingPlugin.sharedInstance?.startCall(data, fromPushKit: true)

        return super.application(application, continue: userActivity, restorationHandler: restorationHandler)
    }

    // Handle updated push credentials
    func pushRegistry(_ registry: PKPushRegistry, didUpdate credentials: PKPushCredentials, for type: PKPushType) {
        let deviceToken = credentials.token.map { String(format: "%02x", $0) }.joined()
        //Save deviceToken to your server
        SwiftFlutterCallkitIncomingPlugin.sharedInstance?.setDevicePushTokenVoIP(deviceToken)
    }

    func pushRegistry(_ registry: PKPushRegistry, didInvalidatePushTokenFor type: PKPushType) {
        SwiftFlutterCallkitIncomingPlugin.sharedInstance?.setDevicePushTokenVoIP("")
    }

    // Handle incoming pushes
    func pushRegistry(_ registry: PKPushRegistry, didReceiveIncomingPushWith payload: PKPushPayload, for type: PKPushType, completion: @escaping () -> Void) {
        if type == .voIP {
//                print("fuck---------voIP")

                // Xử lý thông báo VoIP
                let nameCaller = payload.dictionaryPayload["nameCaller"] as? String ?? ""
                let handle = payload.dictionaryPayload["handle"] as? String ?? ""
                let isVideo = payload.dictionaryPayload["isVideo"] as? Bool ?? false

                let data = flutter_callkit_incoming_timer.Data(id: UUID().uuidString, nameCaller: nameCaller, handle: handle, type: isVideo ? 1 : 0)
                //set more data
                data.extra = ["user": "abc@123", "platform": "ios"]

                SwiftFlutterCallkitIncomingPlugin.sharedInstance?.showCallkitIncoming(data, fromPushKit: true)
            } else {
                return
                // Nếu không phải VoIP, đẩy dữ liệu về Flutter
//                 let userInfo = payload.dictionaryPayload
//                 sendNotificationDataToFlutter(userInfo: userInfo)
            }
    }

//    private func sendNotificationDataToFlutter(userInfo: [AnyHashable: Any]) {
//        if let flutterViewController = window?.rootViewController as? FlutterViewController {
//            let channel = FlutterMethodChannel(name: "com.yourapp/notifications", binaryMessenger: flutterViewController.binaryMessenger)
//            // Chuyển dữ liệu từ native sang Flutter
//            channel.invokeMethod("notificationReceived", arguments: userInfo)
//        }
//    }
//
//    override func userNotificationCenter(_ center: UNUserNotificationCenter,
//                                didReceive response: UNNotificationResponse,
//                                withCompletionHandler completionHandler: @escaping () -> Void) {
//        // Lấy dữ liệu thông báo
//        let userInfo = response.notification.request.content.userInfo
//        sendNotificationDataToFlutter(userInfo: userInfo)
//
//    }
//
//    override func userNotificationCenter(_ center: UNUserNotificationCenter,
//                             willPresent notification: UNNotification,
//                             withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
//     // Lấy dữ liệu thông báo
//     let userInfo = notification.request.content.userInfo
//     sendNotificationDataToFlutter(userInfo: userInfo)
//
//     // Hiển thị thông báo
//     completionHandler([.alert, .sound, .badge])
//    }


}
