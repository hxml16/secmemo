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
    @IBOutlet weak var addMemoButton: UIButton!

    private let disposeBag = DisposeBag()
    var viewModel: MemosViewModel?
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBindings()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel?.rebuildDataSource()
    }
}

//MARK: Bindings
extension MemosViewController {
    private func setupBindings() {
        guard let viewModel = viewModel else { return }
        viewModel.resetRowSelectedIndex()
        self.navigationItem.rightBarButtonItem?.rx.tap.subscribe(onNext: { [weak self] in
            self?.requestNewDocument()
        }).disposed(by: disposeBag)
        
        self.navigationItem.leftBarButtonItem?.rx.tap.subscribe(onNext: {
            viewModel.requestSettigns()
        }).disposed(by: disposeBag)
        
        addMemoButton.rx.tap.subscribe(onNext: { [weak self] in
            self?.requestNewDocument()
        }).disposed(by: disposeBag)

        viewModel.status
            .bind(to: statusLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.addMemoControlVisible
            .bind(to: addMemoButton.rx.visible)
            .disposed(by: disposeBag)                

        if UIDevice.isPad {
            viewModel.rowIndexSelected
                .subscribe(onNext: {[weak self] rowIndex in
                    if rowIndex >= 0 {
                        self?.tableView.selectRow(at: IndexPath(row: rowIndex, section: 0), animated: false, scrollPosition: .top)
                    }
                })
                .disposed(by: disposeBag)
        }

        bindTableView()
    }
    
    private func bindTableView() {
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
        tableView.register(UINib(nibName: MemosTableCellsFactory.Constants.memoTableViewCellIdentifier, bundle: nil), forCellReuseIdentifier: MemosTableCellsFactory.Constants.memoTableViewCellIdentifier)
        
        viewModel?.items.bind(to: tableView.rx.items(cellIdentifier: MemosTableCellsFactory.Constants.memoTableViewCellIdentifier, cellType: MemoTableViewCell.self)) { (row, memoHeader, cell) in
            cell.memoHeader = memoHeader
            if UIDevice.isPad {
                cell.selectionStyle = .gray
            }
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
    
    private func requestNewDocument() {
        viewModel?.requestNewDocument()
    }
}

//MARK: UITableViewDelegate
extension MemosViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Constants.estimatedRowHeight
    }
}
