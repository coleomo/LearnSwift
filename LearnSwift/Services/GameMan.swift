//
//  GameMan.swift
//  LearnSwift
//
//  Created by song on 2025/12/12.
//
import ARKit
import Combine
import RealityKit

// 游戏核心控制器: 兼顾数据通知
class GameManager: ObservableObject {
    // 单利模式
    @usableFromInline static let shared = GameManager()
    @usableFromInline init() {}

    // 游戏状态
    @Published var gameState: GameState = .ready

    // Arview 视图
    private var arView: ARView?

    // 配置arview
    func setupArView(_ arView: ARView) {
        self.arView = arView
    }
}
