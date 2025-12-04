//
//  ContentView.swift
//  LearnSwift
//
//  Created by song on 2025/12/3.
//

import AVFoundation
import SwiftData
import SwiftUI

struct ContentView: View {
    // 存储识别到的二维码角点
    @State var corners = QRCorners()

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
                }
            }
        }.edgesIgnoringSafeArea(.all)
    }
}

// 预览
#Preview {
    ContentView()
}
