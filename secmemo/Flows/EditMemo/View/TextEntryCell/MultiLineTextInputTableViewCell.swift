//
//  MultiLineTextInputTableViewCell.swift
//  ER Pro
//
//  Created by Damien Pontifex on 7/08/2014.
//  Copyright (c) 2014 Evoque Rehab. All rights reserved.
//

import UIKit

class MultiLineTextInputTableViewCell: UITableViewCell {
    @IBOutlet var textView: UITextView?
	
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String!) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
	/// Custom setter so we can initialise the height of the text view
	var textString: String {
		get {
			return textView?.text ?? ""
		}
		set {
			if let textView = textView {
				textView.text = newValue				
				textViewDidChange(textView)
			}
		}
	}

    override func awakeFromNib() {
        super.awakeFromNib()
		
		// Disable scrolling inside the text view so we enlarge to fitted size
        textView?.textContainerInset = .zero
        textView?.textContainer.lineFragmentPadding = 0
        textView?.isScrollEnabled = false
        textView?.delegate = self
        
        // Enable dynamic type adjustments
        textView?.adjustsFontForContentSizeCategory = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        if selected {
            textView?.becomeFirstResponder()
        }
    }
    
    func focusTextView() {
        textView?.becomeFirstResponder()
    }
}

extension MultiLineTextInputTableViewCell: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
		let size = textView.bounds.size
		let newSize = textView.sizeThatFits(CGSize(width: size.width, height: CGFloat.greatestFiniteMagnitude))
		
        if size.height != newSize.height {
			UIView.setAnimationsEnabled(false)
			tableView?.beginUpdates()
			tableView?.endUpdates()
			UIView.setAnimationsEnabled(true)
			
			if let thisIndexPath = tableView?.indexPath(for: self) {
				tableView?.scrollToRow(at: thisIndexPath, at: .bottom, animated: false)
			}
		}
    }
}
