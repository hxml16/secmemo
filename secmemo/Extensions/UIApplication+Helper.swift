//
//  UIApplication+Helper.swift
//  secmemo
//
//  Created by heximal on 11.02.2022.
//

import Foundation
import UIKit

//MARK: Application life cycle routines
extension UIApplication {
    class func topViewController(controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
      if let tabController = controller as? UITabBarController {
        return topViewController(controller: tabController.selectedViewController)
      }
      if let navController = controller as? UINavigationController {
        return topViewController(controller: navController.visibleViewController)
      }
      if let presented = controller?.presentedViewController {
        return topViewController(controller: presented)
      }
      return controller
    }
}
