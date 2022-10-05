import UIKit
import Flutter
import Foundation
import SwiftUI
import SupportProvidersSDK
import AnswerBotProvidersSDK
import ZendeskCoreSDK
import ChatProvidersSDK
import AnswerBotSDK
import SupportSDK
import ChatSDK
import MessagingSDK
import ZendeskCoreSDK

import ZendeskCoreSDK
import SupportProvidersSDK
import AnswerBotProvidersSDK
import ChatProvidersSDK


protocol EventTypeDelegate{
    func eventProtocol(errorMessage : String)
}

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate, EventTypeDelegate {
    var flutterResult : FlutterResult?
//    var accountKey = "ZDqsrdoNqC8Q7eUVgryMt5xiu8rNWTyC"
//    var clientId  = "mobile_sdk_client_005d0b759f8b4299b0dd"
//    var url = "https://roava.zendesk.com"
//    var appId = "a682367d013535d0f69b965123aa1a62fa8716dfe7771d30"
    
    // 1.
    //
    // Akey: ZDqsrdoNqC8Q7eUVgryMt5xiu8rNWTyC
    // client id: mobile_sdk_client_005d0b759f8b4299b0dd
    // app id: a682367d013535d0f69b965123aa1a62fa8716dfe7771d30
    // jwt: CzQo6Dv7DWyuYsoy3xNqARgopClHtlAC43sHkOxGlzegCg39
    
    // 2.
    // app id: bb5988da3d1686cd0dd7c446243e2e3e2ff0fb5fc43c8223
    // clientid: mobile_sdk_client_3fe4b9b97be7f57855ac
    // acc key: ZDqsrdoNqC8Q7eUVgryMt5xiu8rNWTyC
    // jwt:
    
    
    
    
    
    
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        CoreLogger.enabled = true
        CoreLogger.logLevel = .debug
        
        
        // Initialize method channel for flutter platform specific implementations
        let channelName = "com.roava.app"
        let rootViewController : FlutterViewController = window?.rootViewController as! FlutterViewController
        let methodChannel = FlutterMethodChannel(name: channelName,
                                                 binaryMessenger: rootViewController as! FlutterBinaryMessenger)
        handleMethodCall(deviceChannel: methodChannel)

        
        GeneratedPluginRegistrant.register(with: self)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    
    
    func eventProtocol(errorMessage: String) {
        if errorMessage.isEmpty {
            flutterResult!("success")
        } else {
            let error = FlutterError(code: "401", message: errorMessage, details: nil)
            flutterResult!(error)
        }
    }
    
    private func handleMethodCall(deviceChannel: FlutterMethodChannel){
        deviceChannel.setMethodCallHandler({
            (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
            
            var zendeskService: ZendeskService{
                return ZendeskService(window: self.window) {event in
                    self.eventProtocol(errorMessage: event)
                }
            }
            
            if call.method == "launch_unified" {
                
                self.flutterResult = result;
                zendeskService.initializeZendesk()
                result("Ok")
                
            }
            else {
                result(FlutterMethodNotImplemented)
                return
            }
            
        })
    }
    
    
}
