//
//  MemosMasterDetailsViewController.swift
//  secmemo
//
//  Created by heximal on 19.04.2022.
//

import Foundation
import RxSwift
import RxCocoa
import UIKit

//MARK: Declarations and life cycle
class MemosMasterDetailsViewController: UISplitViewController, Storyboarded {
    static var storyboard = AppStoryboard.memosMasterDetails

    private let disposeBag = DisposeBag()
    var viewModel: MemosMasterDetailsViewModel?
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func splitViewController(splitViewController: UISplitViewController, collapseSecondaryViewController secondaryViewController:UIViewController!, ontoPrimaryViewController primaryViewController:UIViewController!) -> Bool {
        return false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let navigationBar = navigationController?.navigationController?.navigationBar ?? navigationController?.navigationBar
        navigationBar?.isHidden = true
    }
}

//MARK: UI
extension MemosMasterDetailsViewController {
    private func setupUI() {
        preferredDisplayMode = .allVisible
    }
}

