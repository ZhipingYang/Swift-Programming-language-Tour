//
//  ProtocolViewController.swift
//  EasyChat
//
//  Created by XcodeYang on 06/04/2017.
//  Copyright © 2017 XcodeYang. All rights reserved.
//

import UIKit

private let url_1 = "1.jpg"
private let url_2 = "2.jpg"
private let url_3 = "3.jpeg"
private let text_str = "By conforming to these protocols, custom collection types can gain access to the same language constructs and powerful top-level functions we use with Array and Dictionary."


protocol ChatModelProtocol {
    var position: Position {get}
    var textStr: String? {get}
    var urlStr: String? {get}
}

protocol RandomProtocol {
    associatedtype itemType
    static func random() -> itemType
}

extension RandomProtocol where Self: ChatModelProtocol {
    static func random() -> ChatModel {
        let isLeft = Int(arc4random())%2 == 0
        let isTextMessage = Int(arc4random())%2 == 0
        
        if isTextMessage {
            let randomNum = Int(arc4random())%(text_str.characters.count-20)+20
            let index = text_str.index(text_str.startIndex, offsetBy: randomNum)
            let messageText = text_str.substring(to: index)
            return ChatModel.textMessage(data: (position: isLeft ? .left: .right, text: messageText))
        } else {
            let imageUrl = [url_1, url_2, url_3][Int(arc4random())%3]
            return ChatModel.imageMessage(data: (position: isLeft ? .left: .right, text: imageUrl))
        }
    }
}


















//
//protocol BackActionProtocol {
//    var backItem: UIBarButtonItem { get }
//    func backAction(animation: Bool)
//}
//
//extension BackActionProtocol where Self: UIViewController {
//    
////    var backItem: UIBarButtonItem {
////        let backItem = UIBarButtonItem.init(title: "返回", style: .plain, target: self.navigationController, action: #selector(backAction(animation:)))
////        return backItem
////    }
//    func backAction(animation: Bool = true) {
//        guard let nav = self.navigationController else { return }
//        if nav.viewControllers.count>1 {
//            nav.popViewController(animated: animation)
//        } else if nav.viewControllers.count==1 {
//            nav.dismiss(animated: animation, completion: nil)
//        }
//    }
//}
//
//class viewC: UIViewController,BackActionProtocol {
//    var backItem: UIBarButtonItem {
//        let backItem = UIBarButtonItem.init(title: "返回", style: .plain, target: self.navigationController, action: #selector(haha))
//        return backItem
//    }
//    
//    func haha() {
//        backAction(animation: true)
//    }
//}

