//
//  TextCell.swift
//  EasyChat
//
//  Created by XcodeYang on 07/04/2017.
//  Copyright © 2017 XcodeYang. All rights reserved.
//

import UIKit

class TextCell: UITableViewCell {

    @IBOutlet weak var textMessageLabel: UILabel!
    @IBOutlet weak var trailing: NSLayoutConstraint!
    @IBOutlet weak var leading: NSLayoutConstraint!
    
    var item: ChatModelProtocol! {
        didSet {
            textMessageLabel.text = item.textStr
            leading.constant = item.position == .left ? 0:100
            trailing.constant = item.position == .left ? 100:0
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
