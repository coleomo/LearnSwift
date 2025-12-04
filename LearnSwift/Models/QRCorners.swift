//
//  QRCorners.swift
//  LearnSwift
//
//  Created by song on 2025/12/4.
//

import SwiftUI

// 定义存储四个顶点的坐标
struct QRCorners {
    var topLeft: CGPoint = .zero
    var topRight: CGPoint = .zero
    var bottomLeft: CGPoint = .zero
    var bottomRight: CGPoint = .zero

    // 只有当所有点都不是原点的时候才能被认为是有效的
    var isValid: Bool {
        return topLeft != .zero && topRight != .zero && bottomLeft != .zero && bottomRight != .zero
    }
}
