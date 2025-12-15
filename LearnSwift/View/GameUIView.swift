//
//  GameUIView.swift
//  LearnSwift
//
//  Created by song on 2025/12/15.
//
import SwiftUI

struct GameUIView: View {
    var body: some View {
        VStack {
            HStack {
                Text("左侧分数")
                Spacer()
                Text("右侧状态")
            }
            .foregroundStyle(.red)
            .padding(.horizontal)
            // 撑开上下
            Spacer()
            // 底部控制
            Button("开始游戏") {
                print("开始游戏")
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 10)
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
        }
    }
}
