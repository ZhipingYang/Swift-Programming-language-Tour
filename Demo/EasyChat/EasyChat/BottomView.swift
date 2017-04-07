//
//  a.swift
//  EasyChat
//
//  Created by XcodeYang on 07/04/2017.
//  Copyright © 2017 XcodeYang. All rights reserved.
//

import UIKit

class BottomView: UIView {
    
    lazy var textField: UITextField = {
        var txf = UITextField()
        txf.placeholder = "请输入内容"
        txf.returnKeyType = UIReturnKeyType.send
        return txf
    }()
    
    lazy var imageButton:UIButton = {
        let btn = UIButton(type: .custom)
        btn.setTitle("图片", for: .normal)
        btn.backgroundColor = UIColor.red
        return btn
    }()
    
    var sendTextBlock:((String)->Void)?
    var sendImageBlock:((String)->Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        self.textField.delegate = self
        self.imageButton.addTarget(self, action: #selector(btnClick), for: .touchUpInside)
        self.addSubview(textField)
        self.addSubview(imageButton)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        textField.frame = CGRect(x: 0, y: 0, width: bounds.width-50, height: bounds.height)
        imageButton.frame = CGRect(x: textField.frame.maxX, y: 0, width: 50, height: bounds.height)
    }
    
    func btnClick() {
        sendImageBlock?("1.jpg")
    }
}

extension BottomView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let text = textField.text, text.isEmpty==false else {
            return false
        }
        sendTextBlock?(text)
        textField.text = nil
        return true
    }
}
