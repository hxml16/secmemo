//
//  ViewControllerUtils.swift
//  secmemo
//
//  Created by heximal on 09.02.2022.
//

import Foundation
import UIKit

enum ViewControllerUtils {
    static func setRootViewController(window: UIWindow, viewController: UIViewController, withAnimation: Bool) {
        if !withAnimation {
            window.rootViewController = viewController
            window.makeKeyAndVisible()
            return
        }

        if let snapshot = window.snapshotView(afterScreenUpdates: true) {
            viewController.view.addSubview(snapshot)
            window.rootViewController = viewController
            window.makeKeyAndVisible()
            
            UIView.animate(withDuration: 0.4, animations: {
                snapshot.layer.opacity = 0
            }, completion: { _ in
                snapshot.removeFromSuperview()
            })
        }
    }
    
    static func presentViewController(viewController: UIViewController, inViewController: UIViewController, withAnimation: Bool) {
        viewController.modalPresentationStyle = .fullScreen
        inViewController.present(viewController, animated: withAnimation, completion: nil)
    }
}
