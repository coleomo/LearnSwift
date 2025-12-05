//
//  CornerAngle.swift
//  LearnSwift
//
//  Created by song on 2025/12/5.
//

import SwiftUI

struct CornerAngle: View {
    // 存储识别到的二维码角点
    @State var corners = QRCorners()
    // 用于文本偏移的常量
    let textOffset: CGFloat = 30

    var body: some View {
        ZStack {
            // 相机扫描器视图
            CameraScanner(corners: $corners)
            // 如果识别到有效的角点，则绘制边框
            if corners.isValid {
                ZStack {
                    // 左上方是红色，右上方是绿色，左下方是蓝色，右下方是黄色
                    CircleView(color: .red, point: corners.topLeft)
                    CircleView(color: .green, point: corners.topRight)
                    CircleView(color: .blue, point: corners.bottomLeft)
                    CircleView(color: .yellow, point: corners.bottomRight)
                    // 绘制连接四个角点的边框
                    Path { path in
                        path.move(to: corners.topLeft)
                        path.addLine(to: corners.topRight)
                        path.addLine(to: corners.bottomRight)
                        path.addLine(to: corners.bottomLeft)
                        path.closeSubpath()
                    }.stroke(Color.white, lineWidth: 5)
                    // 1. 左上角 (TopLeft)
                    AngleTextView(angle: topLeftAngle)
                        .position(x: corners.topLeft.x + textOffset,
                                  y: corners.topLeft.y + textOffset)

                    // 2. 右上角 (TopRight)
                    AngleTextView(angle: topRightAngle)
                        .position(x: corners.topRight.x - textOffset,
                                  y: corners.topRight.y + textOffset)

                    // 3. 右下角 (BottomRight)
                    AngleTextView(angle: bottomRightAngle)
                        .position(x: corners.bottomRight.x - textOffset,
                                  y: corners.bottomRight.y - textOffset)

                    // 4. 左下角 (BottomLeft)
                    AngleTextView(angle: bottomLeftAngle)
                        .position(x: corners.bottomLeft.x + textOffset,
                                  y: corners.bottomLeft.y - textOffset)
                }
            }
        }.edgesIgnoringSafeArea(.all)
    }
}
