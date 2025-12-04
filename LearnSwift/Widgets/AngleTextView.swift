//
//  AngleTextView.swift
//  LearnSwift
//
//  Created by song on 2025/12/4.
//

import SwiftUI

// MARK: - 角度文本组件 (AngleTextView)
struct AngleTextView: View {
    let angle: Double

    var body: some View {
        Text("\(angle, specifier: "%.1f")°") // 显示一位小数并加上度数符号
            .font(.caption)
            .fontWeight(.bold)
            .foregroundColor(.white)
            .padding(4)
            .background(Color.black.opacity(0.6))
            .cornerRadius(5)
    }
}
