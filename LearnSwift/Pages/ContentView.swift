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
    // 视图主体
    var body: some View {
        // 角点和角度
        // CornerAngle()
        // 通过边距形变测方位
        // VisionDis()
        // 用UIViewController例子
        // LoginRegisterView()
        // 平面检测
        // PlaneArLayout()
        ZStack {
            // AR游戏的内容视图
            // 把.ignoresSafeArea(.all)放在ARview层，可以防止gameui层出现在安全区域
            ImageARView()
                .ignoresSafeArea(.all)

            // 因为需要界面操作，需要添加一个界面上的控制ui层，用于显示开始、暂停、分数等
            GameUIView()
        }
        // 如果把.ignoresSafeArea(.all)放在最外层，就会导致gamui层出现在安全区域中
    }
}

// 预览
#Preview {
    ContentView()
}
