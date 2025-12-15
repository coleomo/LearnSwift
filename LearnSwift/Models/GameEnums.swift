//
//  GameEnums.swift
//  LearnSwift
//
//  Created by song on 2025/12/12.
//

// 游戏状态枚举
enum GameState {
    // 准备
    case ready
    // 正在游戏
    case playing
    // 暂停
    case pause
    // 结束
    case over
}

// 服务器连接状态
enum ConnectState {
    // 正在连接
    case connecting
    // 已连接
    case connected
    // 连接失败
    case failed
    // 断开连接
    case disconnected
}
