//
//  CircleView.swift
//  LearnSwift
//
//  Created by song on 2025/12/4.
//

import SwiftUI

// 辅助视图，画原点
struct CircleView: View {
    let color: Color
    let point: CGPoint
    // 视图主体
    var body: some View {
        Circle()
            .fill(color)
            .frame(width: 20, height: 20)
            .position(point)
            .shadow(radius: 5)
    }
}
