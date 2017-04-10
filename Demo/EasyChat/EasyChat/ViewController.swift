//
//  ViewController.swift
//  EasyChat
//
//  Created by XcodeYang on 06/04/2017.
//  Copyright © 2017 XcodeYang. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    lazy var tableView: UITableView = {
        let tableView = UITableView.init(frame: .zero, style: .plain)
        tableView.estimatedRowHeight = 60
        tableView.register(UINib.init(nibName: String(describing: TextCell.self), bundle: nil), forCellReuseIdentifier: String(describing: TextCell.self))
        tableView.register(UINib.init(nibName: String(describing: ImageCell.self), bundle: nil), forCellReuseIdentifier: String(describing: ImageCell.self))
        tableView.separatorStyle = .none
        return tableView
    }()
    
    lazy var bottomView: BottomView = {
        let bottomView = BottomView(frame: .zero)
        bottomView.sendTextBlock = {[unowned self] str in
            let model = ChatModel.textMessage(data: (position: Position.right, text: str))
            self.dataArray.append(model)
            self.tableView.reloadData()
            self.tableView.scrollToBottom()
        }
        bottomView.sendImageBlock = {[unowned self] str in
            let model = ChatModel.imageMessage(data: (position: .right, text: str))
            self.dataArray.append(model)
            self.tableView.reloadData()
            self.tableView.scrollToBottom()
        }
        return bottomView
    }()
    
    var dataArray = [ChatModelProtocol]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        view.addSubview(bottomView)
        
        (0..<20).forEach { _ in
           dataArray.append(ChatModel.random())
        }
        addNotification()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        var frame = view.bounds
        frame.size.height -= 40
        tableView.frame = frame
        bottomView.frame = CGRect(x: 0, y: frame.maxY, width: frame.width, height: 40)
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = dataArray[indexPath.row] as! ChatModel
        
        if case ChatModel.imageMessage(data: _) = item {
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ImageCell.self)) as! ImageCell
            cell.item = item
            return cell
        } else if case ChatModel.textMessage(data: (_, _)) = item {
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: TextCell.self)) as! TextCell
            cell.item = item
            return cell
        }
        return UITableViewCell()
    }
}

extension ViewController: UITableViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        view.endEditing(true)
    }
}

// 通知
extension ViewController {
    
    func addNotification() {
        let center = NotificationCenter.default
        center.addObserver(self,
                           selector: #selector(keyboardWillShow(_:)),
                           name: .UIKeyboardWillShow,
                           object: nil)
        
        center.addObserver(self,
                           selector: #selector(keyboardWillHide(_:)),
                           name: .UIKeyboardWillHide,
                           object: nil)
    }
    
    func keyboardWillShow(_ noti:NSNotification) {
        UIView.animate(withDuration: 0.25) { 
            self.bottomView.frame = CGRect.init(x: 0, y: self.view.bounds.height-40-256, width: self.view.bounds.width, height: 40)
        }
    }
    
    func keyboardWillHide(_ noti:NSNotification) {
        UIView.animate(withDuration: 0.25) {
            self.bottomView.frame = CGRect.init(x: 0, y: self.view.bounds.height-40, width: self.view.bounds.width, height: 40)
        }
    }
}

extension UIScrollView {
    func scrollToBottom() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            let size = self.contentSize
            self.scrollRectToVisible(CGRect(x: 0, y: size.height-1, width: 1, height: 1), animated: true)
        }
    }
}
