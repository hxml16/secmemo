//
//  EditMemoViewController+Bindings.swift
//  secmemo
//
//  Created by heximal on 01.05.2022.
//

import Foundation
import UIKit
import RxSwift
import RxKeyboard

//MARK: Bindings
extension EditMemoViewController {
    internal func setupBindings() {
        bindViewModelMembers()
        bindControls()
        bindOnscreenKeyboard()
        bindTableView()
        bindSessionService()
    }
    
    internal func bindSessionService() {
        let sessionService = AppDelegate.container.resolve(SessionService.self)!
        sessionService.didCleanupData
            .subscribe(onNext: { [weak self] in
                self?.viewModel?.emptyfyMemo()
                self?.viewModel = nil
                self?.navigationController?.popViewController(animated: false)
        })
        .disposed(by: disposeBag)
    }
    
    internal func bindViewModelMembers() {
        viewModel?.entriesCount
            .subscribe(onNext: { [weak self] count in
                if let strongSelf = self {
                    strongSelf.entryEditDescriptionLabelHeightConstraint.constant = count > 0 ? 0 : strongSelf.initialTableViewBottomOffset
                }
            })
            .disposed(by: disposeBag)
        
        viewModel?.didRequestPhotoLibrary
            .subscribe(onNext: { [weak self] in
                if let strongSelf = self {
                    strongSelf.imagePicker.pickPhotoFromLibrary(inController: strongSelf) { [weak self] pickedImage in
                        self?.viewModel?.addPhotoEntry(image: pickedImage)
                    }
                }
            })
            .disposed(by: disposeBag)

        viewModel?.didRequestCamera
            .subscribe(onNext: { [weak self] in
                if let strongSelf = self {
                    strongSelf.imagePicker.pickPhotoFromCamera(inController: strongSelf) { [weak self] pickedImage in
                        self?.viewModel?.addPhotoEntry(image: pickedImage)
                    }
                }
            })
            .disposed(by: disposeBag)
        
        viewModel?.didRequestDismission
            .subscribe(onNext: { [weak self] in
                self?.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)

        viewModel?.memoApplied
            .subscribe(onNext: { [weak self] applied in
                self?.uiVisible = applied
            })
            .disposed(by: disposeBag)
        
        viewModel?.bottomButtonsAvailable
            .subscribe(onNext: { [weak self] applied in
                self?.bottomControlsVisible = applied
            })
            .disposed(by: disposeBag)
    }

    internal func bindControls() {
        deleteMemoButton.rx.tap
            .bind { [weak self] in
                self?.viewModel?.removeMemo()
            }
            .disposed(by: disposeBag)

        dismissKeyboardButton.rx.tap
            .bind { [weak self] in
                self?.view.endEditing(true)
            }
            .disposed(by: disposeBag)
        pasteKeyboardButton.rx.tap
            .bind { [weak self] in
                self?.viewModel?.makeCurrentResponderFirst()
            }
            .disposed(by: disposeBag)
        bindAddEntryControls()
    }

    internal func bindAddEntryControls() {
        addTextButton.rx.tap
            .bind { [weak self] in
                self?.viewModel?.addTextEntry()
            }
            .disposed(by: disposeBag)

        addLocationButton.rx.tap
            .bind { [weak self] in
                self?.viewModel?.addLocationEntry()
            }
            .disposed(by: disposeBag)

        addImageButton.rx.tap
            .bind { [weak self] in
                self?.chooseImagePickMethod()
            }
            .disposed(by: disposeBag)

        addLinkButton.rx.tap
            .bind { [weak self] in
                self?.viewModel?.addLinkEntry()
            }
            .disposed(by: disposeBag)
        
        viewModel?.memoTitle
            .bind(to: headerTextView.rx.text)
            .disposed(by: disposeBag)

        viewModel?.memoTitlePlaceholder
            .bind(to: headerTextViewPlaceholder.rx.text)
            .disposed(by: disposeBag)

        headerTextView.rx.text
            .subscribe(onNext: { [weak self] text in
            self?.headerTextViewPlaceholder.visible = text == ""
        }).disposed(by: disposeBag)

        headerTextView.rx.text
            .skip(1)
            .subscribe(onNext: { [weak self] text in
            self?.viewModel?.applyMemoTitle(title: text)
        }).disposed(by: disposeBag)
    }
    
    internal func bindOnscreenKeyboard() {
        RxKeyboard.instance.visibleHeight
          .drive(onNext: { [weak self] keyboardVisibleHeight in
              if let strongSelf = self {
                  let isKeyboardVisible = keyboardVisibleHeight > 0
                  strongSelf.tableViewBottomConstraint.constant = keyboardVisibleHeight
                  strongSelf.keybaordHeaderHeightConstraint.constant = isKeyboardVisible ? strongSelf.initialKeybaordHeaderHeight : 0
                  strongSelf.memoControlsContainerHeightConstraint.constant = isKeyboardVisible ? 0 : strongSelf.initiaMemoControlsContainerHeight
              }
          })
          .disposed(by: disposeBag)
    }
    
    internal func bindTableView() {
        bindHeaderTextView()

        viewModel?.dataSource.bind(to: tableView.rx.items){[weak self] (tableView, row, memoEntry) -> UITableViewCell in
            var tableCell = UITableViewCell()
            guard let strongSelf = self else {
                return tableCell
            }
            self?.viewModel?.preloadEntryData(entry: memoEntry)
            switch memoEntry.type {
                case .location:
                    tableCell = strongSelf.locationCell(row: row, memoEntry: memoEntry)

                case .link:
                    tableCell = strongSelf.linkCell(row: row, memoEntry: memoEntry)

                case .text:
                    tableCell = strongSelf.textCell(row: row, memoEntry: memoEntry)

                case .imageCollection:
                    tableCell = strongSelf.imageCollectionCell(row: row, memoEntry: memoEntry)
                
                default:
                    break
            }
            tableCell.tag = row
            return tableCell
        }.disposed(by: disposeBag)
                
        tableView.rx.itemDeleted
            .subscribe(onNext: { [weak self] indexPath in
                self?.viewModel?.removeEntry(at: indexPath.row)
            })
            .disposed(by: disposeBag)
    }    
    
    internal func bindHeaderTextView() {
        headerTextView.rx.text.subscribe(onNext: { [weak self ] text in
            self?.headerTextLabel.text = text
            self?.headerTextLabel.superview?.layoutIfNeeded()
            guard let headerView = self?.tableView.tableHeaderView, let newBounds = self?.headerLabelWrapper.bounds else {return}
            if headerView.frame.size.height != newBounds.height {
                headerView.frame.size.height = newBounds.height
                self?.tableView.tableHeaderView = headerView
            }
        }).disposed(by: disposeBag)
        
        bindOnBecomeFirstResponder(responder: headerTextView)
    }
    
    internal func bindOnBecomeFirstResponder(responder: UITextView?) {
        responder?.rx.didBeginEditing
            .subscribe(onNext: { [weak self] in
                self?.viewModel?.currentResponder = responder
            })
            .disposed(by: disposeBag)
    }

    internal func bindOnBecomeFirstResponder(responder: UITextField?) {
        responder?.rx.controlEvent([.editingDidBegin])
            .asObservable()
            .subscribe(onNext: { [weak self] _ in
                self?.viewModel?.currentResponder = responder
            })
            .disposed(by: disposeBag)
    }
    
    internal func locationInvalid() {
        showInvalidTextAlert(message: "error.locationInvalid".localized)
    }

    internal func linkInvalid() {
        showInvalidTextAlert(message: "error.linkInvalid".localized)
    }

    internal func showInvalidTextAlert(message: String) {
        showOkAlert(message: message, inController: self)
    }
}
