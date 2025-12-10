//
//  Extension.swift
//  LearnSwift
//
//  Created by song on 2025/12/4.
//
import UIKit

// 示例用法（在 ContentView 中）
extension CornerAngle {
    var topLeftAngle: Double {
        // 角 A (topLeft) 由 B (topRight) 和 D (bottomLeft) 构成
        calculateAngle(p1: corners.topRight,
                       vertex: corners.topLeft,
                       p2: corners.bottomLeft)
    }

    var topRightAngle: Double {
        // 角 B (topRight) 由 A (topLeft) 和 C (bottomRight) 构成
        calculateAngle(p1: corners.topLeft,
                       vertex: corners.topRight,
                       p2: corners.bottomRight)
    }

    // ... 其他两个角同理
    var bottomLeftAngle: Double {
        // 角 D (bottomLeft) 由 A (topLeft) 和 C (bottomRight) 构成
        calculateAngle(p1: corners.topLeft,
                       vertex: corners.bottomLeft,
                       p2: corners.bottomRight)
    }

    var bottomRightAngle: Double {
        // 角 C (bottomRight) 由 B (topRight) 和 D (bottomLeft) 构成
        calculateAngle(p1: corners.topRight,
                       vertex: corners.bottomRight,
                       p2: corners.bottomLeft)
    }
}

