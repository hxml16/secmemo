//
//  MemosViewController.swift
//  secmemo
//
//  Created by heximal on 09.02.2022.
//

import Foundation
import RxSwift
import RxCocoa
import UIKit

//MARK: Declarations and life cycle
class MemosViewController: UIViewController, Storyboarded {
    enum Constants {
        static let estimatedRowHeight: CGFloat = 72.0
    }
    static var storyboard = AppStoryboard.memos
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var statusLabel: UILabel!

    private let disposeBag = DisposeBag()
    var viewModel: MemosViewModel?
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBindings()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel?.rebuildDataSource()        
    }
}

//MARK: Bindings
extension MemosViewController {
    private func setupBindings() {
        guard let viewModel = viewModel else { return }
        self.navigationItem.rightBarButtonItem?.rx.tap.subscribe(onNext: {
            viewModel.requestNewDocument()
        }).disposed(by: disposeBag)
        
        self.navigationItem.leftBarButtonItem?.rx.tap.subscribe(onNext: {
            viewModel.requestSettigns()
            }).disposed(by: disposeBag)
        
        viewModel.status
            .bind(to: statusLabel.rx.text)
            .disposed(by: disposeBag)
        bindTableView()
    }
    
    private func bindTableView() {
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
        tableView.register(UINib(nibName: MemosTableCellsFactory.Constants.memoTableViewCellIdentifier, bundle: nil), forCellReuseIdentifier: MemosTableCellsFactory.Constants.memoTableViewCellIdentifier)
        
        viewModel?.items.bind(to: tableView.rx.items(cellIdentifier: MemosTableCellsFactory.Constants.memoTableViewCellIdentifier, cellType: MemoTableViewCell.self)) { (row, memoHeader, cell) in
            cell.memoHeader = memoHeader
        }.disposed(by: disposeBag)
        
        tableView.rx.modelSelected(MemoHeader.self).subscribe(onNext: { [weak self] memoHeader in
            self?.viewModel?.requestEditDocument(memoHeader: memoHeader)
        }).disposed(by: disposeBag)
        
        tableView.rx.itemDeleted
            .subscribe(onNext: {[weak self] indexPath in
                self?.viewModel?.removeMemo(at: indexPath.row)
            })
            .disposed(by: disposeBag)
    }
}

extension MemosViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Constants.estimatedRowHeight
    }
}
