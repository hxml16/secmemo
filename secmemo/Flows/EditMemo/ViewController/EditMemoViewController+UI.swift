//
//  EditMemoViewController+UI.swift
//  secmemo
//
//  Created by heximal on 01.05.2022.
//

import Foundation
import UIKit

//MARK: UI
extension EditMemoViewController {
    var bottomControlsVisible: Bool {
        get {
            return uiBottomControlViews.count > 0 ? uiBottomControlViews[0].visible : false
        }
        
        set {
            for v in uiBottomControlViews {
                v.visible = newValue
            }
        }
    }

    internal var uiVisible: Bool {
        get {
            return tableView.visible
        }
        
        set {
            self.title = newValue ? "memoEdit.navigationBarTitle".localized : ""
            tableView.visible = newValue
            bottomControlsVisible = newValue
        }
    }

    internal func setupUI() {
        uiVisible = false
        tableView.tableHeaderView = headerTextViewWrapper
        tableView.tableFooterView = addButtonsContainer
        tableView.keyboardDismissMode = .onDrag
        headerTextLabel.font = headerTextView.font

        headerTextView.textContainerInset = .zero
        headerTextView.textContainer.lineFragmentPadding = 0
        headerTextViewPlaceholder.textContainerInset = .zero
        headerTextViewPlaceholder.textContainer.lineFragmentPadding = 0

        initialAddButtonsContainerHeight = addButtonsContainerHeightConstraint.constant
        initialTableViewBottomOffset = tableViewBottomConstraint.constant
        initialEntryEditDescriptionLabelHeight = entryEditDescriptionLabelHeightConstraint.constant
        initialKeybaordHeaderHeight = keybaordHeaderHeightConstraint.constant
        initiaMemoControlsContainerHeight = memoControlsContainerHeightConstraint.constant
        
        tableView.register(UINib(nibName: EditMemoTableCellsFactory.Constants.memoLocationTableViewCellIdentifier, bundle: nil), forCellReuseIdentifier: EditMemoTableCellsFactory.Constants.memoLocationTableViewCellIdentifier)
        tableView.register(UINib(nibName: EditMemoTableCellsFactory.Constants.memoTextEntryTableViewCellIdentifier, bundle: nil), forCellReuseIdentifier: EditMemoTableCellsFactory.Constants.memoTextEntryTableViewCellIdentifier)
        tableView.register(UINib(nibName: EditMemoTableCellsFactory.Constants.memoImageCollectionEntryTableViewCellIdentifier, bundle: nil), forCellReuseIdentifier: EditMemoTableCellsFactory.Constants.memoImageCollectionEntryTableViewCellIdentifier)
        tableView.register(UINib(nibName: EditMemoTableCellsFactory.Constants.memoLinkTableViewCellIdentifier, bundle: nil), forCellReuseIdentifier: EditMemoTableCellsFactory.Constants.memoLinkTableViewCellIdentifier)
    }
}

//MARK: TableCells generation
extension EditMemoViewController {
    internal func linkCell(row: Int, memoEntry: MemoEntry) -> UITableViewCell {
        let linkCell = EditMemoTableCellsFactory.linkCell(tableView: tableView, row: row, item: memoEntry as! MemoLinkEntry)
        linkCell.onInvalidLink = { [weak self] in
            self?.linkInvalid()
        }
        linkCell.onOpenLink = { [weak self] linkEntry, sourceView in
            self?.openLink(linkEntry: linkEntry, sourceView: sourceView)
        }
    
        focusTextCellIfRequired(focusableCell: linkCell, memoEntry: memoEntry)
        return linkCell
    }
    
    internal func textCell(row: Int, memoEntry: MemoEntry) -> UITableViewCell {
        let textCell = EditMemoTableCellsFactory.textCell(tableView: tableView, row: row, item: memoEntry as! MemoTextEntry)
        focusTextCellIfRequired(focusableCell: textCell, memoEntry: memoEntry)
        return textCell
    }
    
    internal func focusTextCellIfRequired(focusableCell: FocusableEntryCell, memoEntry: MemoEntry) {
        if let focusableTextView = focusableCell.focusableView as? UITextView {
            bindOnBecomeFirstResponder(responder: focusableTextView)
        }
        if let focusableTextField = focusableCell.focusableView as? UITextField {
            bindOnBecomeFirstResponder(responder: focusableTextField)
        }
        if memoEntry === viewModel?.focusOnEntry {
            executeWithDelay {
                self.viewModel?.currentResponder = focusableCell.focusableView
                focusableCell.focus()
            }
            viewModel?.focusOnEntry = nil
        }
    }

    internal func locationCell(row: Int, memoEntry: MemoEntry) -> UITableViewCell {
        let locationCell = EditMemoTableCellsFactory.locationCell(tableView: tableView, row: row, item: memoEntry as! MemoLocationEntry)
        locationCell.onLocationUnavailable = {  [weak self] in
            self?.locationUnavailable()
        }
        locationCell.onInvalidLocation = {  [weak self] in
            self?.locationInvalid()
        }
        locationCell.onOpenLocation = {  [weak self] locationEntry, sourceView in
            self?.openLocation(locationEntry: locationEntry, sourceView: sourceView)
        }
        focusTextCellIfRequired(focusableCell: locationCell, memoEntry: memoEntry)
        return locationCell
    }

    internal func imageCollectionCell(row: Int, memoEntry: MemoEntry) -> UITableViewCell {
        let imageCollectionCell = EditMemoTableCellsFactory.imageCollectionCell(tableView: tableView, row: row, item: memoEntry as! MemoImageCollectionEntry)
        imageCollectionCell.onImageViewerRequested = { [weak self] selectedImageEntry in
            self?.viewModel?.requestImageViewer(selectedImageEntry: selectedImageEntry)
        }
        imageCollectionCell.onDeleteRequested = { [weak self] imageEntryRequestedToDelete in
            self?.viewModel?.removeImageEntry(imageEntry: imageEntryRequestedToDelete)
        }
        return imageCollectionCell
    }
}
