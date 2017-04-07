//
//  ImageCell.swift
//  EasyChat
//
//  Created by XcodeYang on 07/04/2017.
//  Copyright © 2017 XcodeYang. All rights reserved.
//

import UIKit

class ImageCell: UITableViewCell {

    @IBOutlet weak var imageMessageView: UIImageView!
    
    @IBOutlet weak var leading: NSLayoutConstraint!
    @IBOutlet weak var trailing: NSLayoutConstraint!
    
    var item: ChatModelProtocol! {
        didSet {
            imageMessageView.image = UIImage.init(named: item.urlStr ?? "1.jpg")
            leading.constant = item.position == .left ? 0:150
            trailing.constant = item.position == .left ? -150:0
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
