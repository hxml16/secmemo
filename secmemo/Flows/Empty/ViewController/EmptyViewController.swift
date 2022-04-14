//
//  EmptyViewController.swift
//  secmemo
//
//  Created by heximal on 09.02.2022.
//

import Foundation
import RxSwift
import RxCocoa
import UIKit

//MARK: Declarations and life cycle
class EmptyViewController: UIViewController, Storyboarded {
    static var storyboard = AppStoryboard.empty

    private let disposeBag = DisposeBag()
    var viewModel: EmptyViewModel?
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBindings()
    }
}

//MARK: Bindings
extension EmptyViewController {
    private func setupBindings() {
        guard let viewModel = viewModel else { return }        
    }
}

