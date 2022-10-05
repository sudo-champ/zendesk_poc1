//
//  ZendeskViewController.swift
//  Runner
//
//  Created by Philips Nge on 28/09/2022.
//

import Foundation
import UIKit
import MessagingSDK

final class ViewController: UIViewController {
    @available(iOS 13.0, *)
    private var modalBackButton: UIBarButtonItem {
        UIBarButtonItem(barButtonSystemItem: .close,
                        target: self,
                        action: #selector(dismissViewController))
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

//    @IBAction func startMessaging(_ sender: Any) {
//        do {
//            let viewController = try Messaging.instance.buildMessagingViewController()
//            presentModally(viewController)
//        } catch {
//            print(error)
//        }
//    }

    private func pushViewController(_ viewController: UIViewController) {
        self.navigationController?.pushViewController(viewController, animated: true)
    }

    @available(iOS 13.0, *)
    private func presentModally(_ viewController: UIViewController,
                                presenationStyle: UIModalPresentationStyle = .automatic) {
        viewController.navigationItem.leftBarButtonItem = modalBackButton

        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.modalPresentationStyle = presenationStyle
        present(navigationController, animated: true)
    }

    /// Dismiss modal `viewController` action
    @objc private func dismissViewController() {
        navigationController?.dismiss(animated: true, completion: nil)
    }
}
