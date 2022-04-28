//
//  EditMemoViewController.swift
//  secmemo
//
//  Created by heximal on 09.02.2022.
//

import Foundation
import RxSwift
import RxCocoa
import RxKeyboard
import UIKit
import CoreLocation

//MARK: Declarations and life cycle
class EditMemoViewController: UIViewController, Storyboarded {
    @IBOutlet weak var addButtonsContainer: UIView!
    @IBOutlet weak var addButtonsTitlesContainer: UIView!
    @IBOutlet weak var headerTextViewWrapper: UIView!
    @IBOutlet weak var headerTextView: UITextView!
    @IBOutlet weak var headerTextViewPlaceholder: UITextView!
    @IBOutlet weak var headerTextLabel: UILabel!
    @IBOutlet weak var headerLabelWrapper: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var pasteKeyboardButton: UIButton!
    @IBOutlet weak var dismissKeyboardButton: UIButton!
    @IBOutlet weak var addTextButton: UIButton!
    @IBOutlet weak var addFromCameraButton: UIButton!
    @IBOutlet weak var addFromPhotosButton: UIButton!
    @IBOutlet weak var deleteMemoButton: UIButton!
    @IBOutlet weak var addLocationButton: UIButton!
    @IBOutlet weak var tableViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var memoControlsContainerHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var addButtonsContainerHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var entryEditDescriptionLabelHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var keybaordHeaderHeightConstraint: NSLayoutConstraint!
    @IBOutlet var uiBottomControlViews: [UIView]!

    static var storyboard = AppStoryboard.editMemo

    private let disposeBag = DisposeBag()
    var viewModel: EditMemoViewModel?
    var skipped = false
    var initialTableViewBottomOffset: CGFloat = 0
    var initialAddButtonsTitlesBottomOffset: CGFloat = 0
    var initialAddButtonsContainerHeight: CGFloat = 0
    var initialEntryEditDescriptionLabelHeight: CGFloat = 0
    var initialKeybaordHeaderHeight: CGFloat = 0
    var initiaMemoControlsContainerHeight: CGFloat = 0
    var locationService: LocationService?
    lazy var imagePicker = ImagePicker()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        executeWithDelay {
            self.setupBindings()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        viewModel?.save()
    }
}

//MARK: UI
extension EditMemoViewController {
    var uiVisible: Bool {
        get {
            return tableView.visible
        }
        
        set {
            self.title = newValue ? "memoEdit.navigationBarTitle".localized : ""
            tableView.visible = newValue
            bottomControlsVisible = newValue
        }
    }

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

    private func setupUI() {
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
    }
}

//MARK: Bindings
extension EditMemoViewController {
    private func setupBindings() {
        bindViewModelMembers()
        bindControls()
        bindOnscreenKeyboard()
        bindTableView()
        bindSessionService()
    }
    
    private func bindSessionService() {
        let sessionService = AppDelegate.container.resolve(SessionService.self)!
        sessionService.didCleanupData
            .subscribe(onNext: { [weak self] in
                self?.viewModel?.emptyfyMemo()
                self?.viewModel = nil
                self?.navigationController?.popViewController(animated: false)
        })
        .disposed(by: disposeBag)
    }
    
    private func bindViewModelMembers() {
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

    private func bindControls() {
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

    private func bindAddEntryControls() {
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

        addFromCameraButton.rx.tap
            .bind { [weak self] in
                self?.viewModel?.requestCameraEntry()
            }
            .disposed(by: disposeBag)

        addFromPhotosButton.rx.tap
            .bind { [weak self] in
                self?.viewModel?.requestPhotoEntry()
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
    
    private func bindOnscreenKeyboard() {
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
    
    private func bindTableView() {
        bindHeaderTextView()

        viewModel?.dataSource.bind(to: tableView.rx.items){[weak self] (tableView, row, memoEntry) -> UITableViewCell in
            self?.viewModel?.preloadEntryData(entry: memoEntry)
            var tableCell = UITableViewCell()
            switch memoEntry.type {
                case .location:
                    let locationCell = EditMemoTableCellsFactory.locationCell(tableView: tableView, row: row, item: memoEntry as! MemoLocationEntry)
                    locationCell.onLocationUnavailable = {
                        self?.locationUnavailable()
                    }
                    locationCell.onInvalidLocation = {
                        self?.locationInvalid()
                    }
                    locationCell.onOpenLocation = { locationEntry, sourceView in
                        self?.openLocation(locationEntry: locationEntry, sourceView: sourceView)
                    }
                
                    tableCell = locationCell
                    self?.bindOnBecomeFirstReponsder(responder: locationCell.locationTextField)
                
                case .text:
                    let textCell = EditMemoTableCellsFactory.textCell(tableView: tableView, row: row, item: memoEntry as! MemoTextEntry)
                    tableCell = textCell
                    if memoEntry === self?.viewModel?.focusOnEntry {
                        executeWithDelay {
                            self?.viewModel?.currentResponder = textCell.textView
                            textCell.focusTextView()
                        }
                        self?.bindOnBecomeFirstResponder(responder: textCell.textView)
                        self?.viewModel?.focusOnEntry = nil
                    }
                
                case .imageCollection:
                    let imageCollectionCell = EditMemoTableCellsFactory.imageCollectionCell(tableView: tableView, row: row, item: memoEntry as! MemoImageCollectionEntry)
                    imageCollectionCell.onImageViewerRequested = { [weak self] selectedImageEntry in
                        self?.viewModel?.requestImageViewer(selectedImageEntry: selectedImageEntry)
                    }
                    imageCollectionCell.onDeleteRequested = { [weak self] imageEntryRequestedToDelete in
                        self?.viewModel?.removeImageEntry(imageEntry: imageEntryRequestedToDelete)
                    }
                    tableCell = imageCollectionCell
                
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
    
    private func bindHeaderTextView() {
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
    
    private func bindOnBecomeFirstResponder(responder: UITextView?) {
        responder?.rx.didBeginEditing
            .subscribe(onNext: { [weak self] in
                self?.viewModel?.currentResponder = responder
            })
            .disposed(by: disposeBag)
    }

    private func bindOnBecomeFirstReponsder(responder: UITextField?) {
        responder?.rx.controlEvent([.editingDidBegin])
            .asObservable()
            .subscribe(onNext: { [weak self] _ in
                self?.viewModel?.currentResponder = responder
            })
            .disposed(by: disposeBag)
    }
}

//MARK: Helper methods
extension EditMemoViewController {
    private func openLocation(locationEntry: MemoLocationEntry, sourceView: UIView) {
        view.endEditing(true)
        guard let coordinate = locationEntry.coordinate else { return }


        let alert = UIAlertController(title: "chooseMapApp.alertTitle".localized, message: nil, preferredStyle: .actionSheet)
        if let presenter = alert.popoverPresentationController {
            presenter.sourceView = sourceView
            if let globalBounds = sourceView.globalBounds {
                presenter.sourceRect = globalBounds
            }
        }
        let handlers = LocationUtils.listOfAvailableMapApps(coordinate: coordinate)
        handlers.forEach { (name, url) in
            alert.addAction(UIAlertAction(title: name, style: .default) { _ in
                UIApplication.shared.open(url, options: [:])
            })
        }
        alert.addAction(UIAlertAction(title: "chooseMapApp.copyItemTitle".localized, style: .default) { _ in
            UIPasteboard.general.string = coordinate.formattedValue
        })
        alert.addAction(UIAlertAction(title: "common.cancel".localized, style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)        
    }

    private func locationUnavailable() {
        showOkCancelAlert(message: "error.locationServiceUnavailable".localized, okTitle: "common.alert.settings".localized, inController: self) {
            SystemUtils.openAppSettings()
        } cancelComplete: {
        }
    }

    private func locationInvalid() {
        showOkAlert(message: "error.locationInvalid".localized, inController: self)
    }
}
