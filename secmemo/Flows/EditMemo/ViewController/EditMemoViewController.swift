//
//  EditMemoViewController.swift
//  secmemo
//
//  Created by heximal on 09.02.2022.
//

import Foundation
import RxSwift
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
    @IBOutlet weak var addImageButton: UIButton!
    @IBOutlet weak var addLinkButton: UIButton!
    @IBOutlet weak var deleteMemoButton: UIButton!
    @IBOutlet weak var addLocationButton: UIButton!
    @IBOutlet weak var tableViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var memoControlsContainerHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var addButtonsContainerHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var entryEditDescriptionLabelHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var keybaordHeaderHeightConstraint: NSLayoutConstraint!
    @IBOutlet var uiBottomControlViews: [UIView]!

    static var storyboard = AppStoryboard.editMemo

    internal let disposeBag = DisposeBag()
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
