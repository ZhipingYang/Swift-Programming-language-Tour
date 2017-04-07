//
//  ChatModel.swift
//  EasyChat
//
//  Created by XcodeYang on 07/04/2017.
//  Copyright © 2017 XcodeYang. All rights reserved.
//

import UIKit

// 别名
typealias DataModel = (position: Position, text: String)

// 位置
enum Position {
    case right,left
}

enum ChatModel {
    // 存储
    case textMessage(data:DataModel)
    case imageMessage(data:DataModel)
}

// 计算 属性
extension ChatModel: ChatModelProtocol {
    
    //position
    var position: Position {
        switch self {
        case .imageMessage(data: (let position, text: _)):
            return position
        case .textMessage(data: (let position, text: _)):
            return position
        }
    }
    
    // 属性 text
    var textStr: String? {
        if case .textMessage(data: (_, let text)) = self {
            return text
        }
        return nil
    }
    
    // 属性 url
    var urlStr: String? {
        if case .imageMessage(data: (_, let url)) = self {
            return url
        }
        return nil
    }
}

// 默认实现
extension ChatModel: RandomProtocol {}
