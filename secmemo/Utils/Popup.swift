//
//  Popup.swift
//  secmemo
//
//  Created by heximal on 09.02.2022.
//

import Foundation
import UIKit

func showOkAlert(title: String? = nil, message: String, inController: UIViewController) {
    showOkAlert(title: title, message: message, inController: inController, handler: nil)
}

func showOkErrorAlert(message: String, inController: UIViewController) {
    showOkAlert(title: "common.error".localized, message: message, inController: inController, handler: nil)
}

func showOkAlert(title: String? = nil, message: String, inController: UIViewController, handler: (() -> Void)?) {
    var titleStr = ""
    if let title = title {
        titleStr = title
    }
    let alert = UIAlertController(title: titleStr, message: message, preferredStyle: UIAlertController.Style.alert)
    alert.addAction(UIAlertAction(title: "common.ok".localized, style: .default, handler: { action in
        switch action.style{
            case .default:
                handler?()
            case .cancel:
                handler?()
            case .destructive:
                handler?()
            default:
                break
        }}))
    inController.present(alert, animated: true, completion: nil)
}

func showOkCancelAlert(message: String, okTitle: String, inController: UIViewController?, okComplete: @escaping () -> Void, cancelComplete: @escaping () -> Void) {
    let title = ""
    let alert = UIAlertController(title: title, message: message, preferredStyle:  UIAlertController.Style.alert)
    alert.addAction(UIAlertAction(title: okTitle, style: .destructive, handler: { action in
        switch action.style{
            case .default:
                okComplete()
                break
            case .cancel:
                break
            case .destructive:
            okComplete()
                break
            default:
                break
        }}))
    alert.addAction(UIAlertAction(title: "common.cancel".localized, style: .default, handler: { action in
        switch action.style{
            case .default:
                cancelComplete()
                break
            case .cancel:
                break
            case .destructive:
                break
            default:
                break
        }}))
    if let inController = inController {
        inController.present(alert, animated: true, completion: nil)
    } else {
        var rootViewController = UIApplication.shared.keyWindow?.rootViewController
        if let navigationController = rootViewController as? UINavigationController {
            rootViewController = navigationController.viewControllers.last
        }
        if let tabBarController = rootViewController as? UITabBarController {
            rootViewController = tabBarController.selectedViewController
        }
        rootViewController?.present(alert, animated: true, completion: nil)
    }
}
