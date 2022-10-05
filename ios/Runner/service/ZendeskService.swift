//
//  ZendeskService.swift
//  Runner
//
//  Created by Philips Nge on 11/08/2022.
//


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
import CommonUISDK






class ZendeskService {
    var window: UIWindow?
    var navigationController: UIViewController?
    
   // let jwtToken = "YnM7IJvVjosGufhz2jAMOAqz9vJe1U4GkEGuwoNzRD6ci1hY"
    var accountKey = "ZDqsrdoNqC8Q7eUVgryMt5xiu8rNWTyC"
    var clientId  = "mobile_sdk_client_005d0b759f8b4299b0dd"
    var url = "https://roava.zendesk.com"
    var appId = "a682367d013535d0f69b965123aa1a62fa8716dfe7771d30"
    
    
    
    init(window: UIWindow, onEvent: @escaping (_ event: String) -> Void) {
        self.window = window
    }
    
    

        let rootViewControllerCV = UIViewController()
    
    func initializeZendesk() -> Void{
        Zendesk.initialize(appId:appId, clientId: clientId, zendeskUrl: url)
        createIdentity(name: "philips", email: "uche@yopmail.com")
        
        Support.initialize(withZendesk: Zendesk.instance)
        AnswerBot.initialize(withZendesk: Zendesk.instance, support: Support.instance!)
        Chat.initialize(accountKey: accountKey)
        
        
        do {
            try  presentModally()
            
            
            
        }catch let error {
            print(error.localizedDescription)
        }
        
    }
    

       static var themeColor: UIColor? {
           didSet {
               guard let themeColor = themeColor else { return }
               CommonTheme.currentTheme.primaryColor = themeColor
           }
       }
    
    
    // MARK: Configurations
      var messagingConfiguration: MessagingConfiguration {
          let messagingConfiguration = MessagingConfiguration()
          messagingConfiguration.name = "Chat Bot"
          messagingConfiguration.isMultilineResponseOptionsEnabled = true
          return messagingConfiguration
      }

      var chatConfiguration: ChatConfiguration {
          let chatConfiguration = ChatConfiguration()
          chatConfiguration.isAgentAvailabilityEnabled = false
          chatConfiguration.isPreChatFormEnabled = true
          return chatConfiguration
      }

      var chatAPIConfig: ChatAPIConfiguration {
          let chatAPIConfig = ChatAPIConfiguration()
          chatAPIConfig.tags = ["iOS", "chat_v2"]
          return chatAPIConfig
      }
    
    func createIdentity(name: String, email: String) -> Void{
        let identity = Identity.createAnonymous(name: name, email: email)
        
        /// when BE sets up endpoint for jwt we get jwt token
        // let authUser =  Identity.createJwt(token: "Unique_id")
    
        Zendesk.instance?.setIdentity(identity)

    }
    
    func buildUI() throws -> UIViewController {
        let messagingConfiguration = MessagingConfiguration()
        messagingConfiguration.name = "Rova Asistant"
        messagingConfiguration.isMultilineResponseOptionsEnabled = true
        
        
        
        let answerBotEngine = try AnswerBotEngine.engine()
        let supportEngine = try  SupportEngine.engine()
        let chatEngine = try ChatEngine.engine()
        Chat.instance?.configuration = chatAPIConfig

        
        return try Messaging.instance.buildUI(engines: [answerBotEngine, supportEngine,chatEngine],
                                              configs: [messagingConfiguration, chatConfiguration])
    }
    
    private func buildTicketScreen() throws ->Void {
        let controller =   window?.rootViewController as! FlutterViewController

        let customFieldOne = CustomField(fieldId: 1234567, value: "some_value")

        let config = RequestUiConfiguration()
        config.subject = "iOS Ticket"
        config.tags = ["ios", "mobile"]
        config.customFields = [customFieldOne]
//        let requestListController = RequestUi.buildRequestList()
        let requestController = RequestUi.buildRequestUi(with: [config])
         controller.show(requestController, sender: self)
    }
    
    
    private func presentModally() throws{
        
        let controller =   window?.rootViewController as! FlutterViewController
        
        let viewController = try buildUI()
        
        let button = UIBarButtonItem(title: "Close", style: .plain, target: self, action: #selector(dismissViewController))
        viewController.navigationItem.leftBarButtonItem = button
        let chatController = UINavigationController(rootViewController: viewController)

       controller.show(chatController,  sender: self)
    }
    
    /// Dismiss modal `viewController` action
      @objc private func dismissViewController() {
          navigationController?.dismiss(animated: true, completion: nil)
      }
    
    @objc private func dismiss()throws {
        self.navigationController = try buildUI()

        self.navigationController?.dismiss(animated: true, completion: nil)    }
}


