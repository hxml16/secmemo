//
//  UIViewController+Extension.swift
//  secmemo
//
//  Created by heximal on 11.02.2022.
//

import Foundation
import UIKit

extension UIViewController {
    func configureDismissKeyboard() {
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:))))
    }
    
    @objc private func handleTap(sender: UITapGestureRecognizer? = nil) {
        sender?.view?.endEditing(true)
    }
    
    func presentOnTop(_ viewController: UIViewController, animated: Bool) {
        topViewController().present(viewController, animated: animated)
    }
    
    func topViewController() -> UIViewController {
        var topViewController = self
        while let presentedViewController = topViewController.presentedViewController {
            topViewController = presentedViewController
        }
        return topViewController
    }
}


public extension UIAlertController {
    func presentOnTop() {
        UIApplication.topViewController()?.present(self, animated: true, completion: nil)
    }
}
