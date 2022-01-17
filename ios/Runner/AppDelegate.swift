import UIKit
import Flutter
import Firebase
import GoogleMaps

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    
    private var eventChannel: FlutterEventChannel?
    private let linkStreamHandler = LinkStreamHandler()
   
    private let channelName = "looklike.beauty"
    private let scheme = "look"
    
    override init() {
        FirebaseApp.configure()
        GMSServices.provideAPIKey("AIzaSyC2enrbrduQm8Ku7fBqdP8gOKanBct4JkQ")
    }
    
    override func application(_ application: UIApplication,
                              didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let controller = window.rootViewController as! FlutterBinaryMessenger
        eventChannel = FlutterEventChannel(name: channelName, binaryMessenger: controller)
        
        GeneratedPluginRegistrant.register(with: self)
        eventChannel?.setStreamHandler(linkStreamHandler)
        
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    override func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
        super.application(application, didRegisterForRemoteNotificationsWithDeviceToken: deviceToken)
    }
    
    override func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        Messaging.messaging().appDidReceiveMessage(userInfo)
    }
    
    override func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        if let scheme = url.scheme {
            if scheme == self.scheme {
                eventChannel?.setStreamHandler(linkStreamHandler)
                return linkStreamHandler.handleLink(url.absoluteString)
            }
        }
        return super.application(app, open: url, options: options)
    }
    
}

class LinkStreamHandler:NSObject, FlutterStreamHandler {
    var eventSink: FlutterEventSink?
    var queuedLinks = [String]()
    
    func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        self.eventSink = events
        queuedLinks.forEach({ events($0) })
        queuedLinks.removeAll()
        return nil
    }
    
    func onCancel(withArguments arguments: Any?) -> FlutterError? {
        self.eventSink = nil
        return nil
    }
    
    func handleLink(_ link: String) -> Bool {
        guard let eventSink = eventSink else {
            queuedLinks.append(link)
            return false
        }
        eventSink(link)
        return true
    }
}
