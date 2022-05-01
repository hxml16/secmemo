//
//  EditMemoViewController+Alerts.swift
//  secmemo
//
//  Created by heximal on 01.05.2022.
//

import Foundation
import UIKit

//MARK: Helper methods
extension EditMemoViewController {
    internal func openLink(linkEntry: MemoLinkEntry, sourceView: UIView) {
        view.endEditing(true)
        guard let linkUrl = linkEntry.text?.url else { return }


        let alert = UIAlertController(title: "memoEdit.alertChooseHyperlinkTitle".localized, message: nil, preferredStyle: .actionSheet)
        if let presenter = alert.popoverPresentationController {
            presenter.sourceView = sourceView
            if let globalBounds = sourceView.globalBounds {
                presenter.sourceRect = globalBounds
            }
        }
        alert.addAction(UIAlertAction(title: "memoEdit.alertOpenHyperlink".localized, style: .default) { _ in
            UIApplication.shared.open(linkUrl)
        })
        alert.addAction(UIAlertAction(title: "memoEdit.alertCopyItemTitle".localized, style: .default) { _ in
            UIPasteboard.general.string = linkUrl.absoluteString
        })
        alert.addAction(UIAlertAction(title: "common.cancel".localized, style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    internal func openLocation(locationEntry: MemoLocationEntry, sourceView: UIView) {
        view.endEditing(true)
        guard let coordinate = locationEntry.coordinate else { return }


        let alert = UIAlertController(title: "memoEdit.alertChooseLocationAppTitle".localized, message: nil, preferredStyle: .actionSheet)
        if let presenter = alert.popoverPresentationController {
            presenter.sourceView = sourceView
            if let globalBounds = sourceView.globalFrame {
                presenter.sourceRect = globalBounds
            }
        }
        let handlers = LocationUtils.listOfAvailableMapApps(coordinate: coordinate)
        handlers.forEach { (name, url) in
            alert.addAction(UIAlertAction(title: name, style: .default) { _ in
                UIApplication.shared.open(url, options: [:])
            })
        }
        alert.addAction(UIAlertAction(title: "memoEdit.alertCopyItemTitle".localized, style: .default) { _ in
            UIPasteboard.general.string = coordinate.formattedValue
        })
        alert.addAction(UIAlertAction(title: "common.cancel".localized, style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    internal func chooseImagePickMethod() {
        view.endEditing(true)
        let alert = UIAlertController(title: "memoEdit.alertChooseImagePickMethodTitle".localized, message: nil, preferredStyle: .actionSheet)
        if let presenter = alert.popoverPresentationController {
            presenter.sourceView = addImageButton
            if let globalBounds = addImageButton.globalBounds {
                presenter.sourceRect = globalBounds
            }
        }
        alert.addAction(UIAlertAction(title: "memoEdit.addFromCameraButtonTitle".localized, style: .default) { _ in
            self.viewModel?.requestCameraEntry()
        })
        alert.addAction(UIAlertAction(title: "memoEdit.addFromPhotosButtonTitle".localized, style: .default) { _ in
            self.viewModel?.requestPhotoEntry()
        })
        alert.addAction(UIAlertAction(title: "common.cancel".localized, style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }

    internal func locationUnavailable() {
        showOkCancelAlert(message: "error.locationServiceUnavailable".localized, okTitle: "common.alert.settings".localized, inController: self) {
            SystemUtils.openAppSettings()
        } cancelComplete: {
        }
    }
}
