//
//  GameUIView.swift
//  LearnSwift
//
//  Created by song on 2025/12/15.
//
import SwiftUI

struct GameUIView: View {
    // 游戏控制
    @StateObject var gameMan = GameManager.shared

    var body: some View {
        VStack {
            HStack {
                Text("分数:\(gameMan.score)")
                Spacer()
                Text("右侧状态")
            }
            .foregroundStyle(.red)
            .padding(.horizontal)
            // 撑开上下
            Spacer()
            // 底部控制
            Group {
                if gameMan.gameState == .playing {
                    Button("暂停游戏") {
                        print("开始游戏")
                    }
                } else if gameMan.gameState == .pause {
                    Button("结束游戏") {
                        print("结束游戏")
                    }
                } else {
                    Button("开始游戏") {
                        print("开始游戏")
                        gameMan.startGame()
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
            }
        }
    }
}
