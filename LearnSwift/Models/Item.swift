//
//  Item.swift
//  LearnSwift
//
//  Created by song on 2025/12/3.
//

import Foundation
import SwiftData


// 本地存储的数据模型
@Model
final class Item {
    // 时间戳属性
    var timestamp: Date
    // 初始化方法
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
