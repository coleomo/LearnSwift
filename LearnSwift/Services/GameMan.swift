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
    static let shared = GameManager()
    private init() {
        print("🎮 GameManager 初始化，地址: \(Unmanaged.passUnretained(self).toOpaque())")
    }

    // 游戏状态
    @Published var gameState: GameState = .ready
    // 游戏分数
    @Published var score: Int = 0
    // 子弹集合，收集子弹id和实体，空字典[:]
    @Published var bullets: [String: Entity] = [:]

    // Arview 视图
    private var arView: ARView?

    // 配置arview
    func setupArView(_ arView: ARView) {
        self.arView = arView
    }

    // 开始游戏逻辑
    func startGame() {
        // 清空之前的状态，并重新开始
        score = 0
        gameState = .playing
        // 点击屏幕发射子弹
        print("开始游戏:\(gameState)")
    }

    // 添加敌人
    func addEnemy() {
        // 在场地平面上随机位置添加一个圆形物体
        print("添加敌人")
    }

    // 玩家发射子弹
    func shoot() {
        print("发射子弹:\(gameState)")
        guard gameState == .playing, let _ = arView else { return }
        // 获取相机位置和前方向
        let cameraTransform = arView!.cameraTransform
        // 获取相机位置
        let cameraPos = SIMD3<Float>(x: cameraTransform.translation.x, y: cameraTransform.translation.y, z: cameraTransform.translation.z)
        // 获取相机朝向
        // 因为这个点是相机当前位置的三维坐标，要想得到朝向，就是这个点的负方向
        let cameraForward = SIMD3<Float>(
            -cameraTransform.matrix.columns.2.x,
            -cameraTransform.matrix.columns.2.y,
            -cameraTransform.matrix.columns.2.z
        )
        // 序列化方向向量
        let forwardVector = normalize(cameraForward)
        // 创建子弹
        generateBullet(pos: cameraPos, forward: forwardVector)
    }

    // 生成子弹
    func generateBullet(pos: SIMD3<Float>, forward: SIMD3<Float>) {
        print("生成子弹")
        guard gameState == .playing, let arView = arView else { return }
        // 生成子弹的id
        let bulletId = UUID().uuidString
        // 创建子弹锚点
        let bulletAnchor = AnchorEntity(world: pos)
        // 创建子弹的网格
        let sphereShape = MeshResource.generateSphere(radius: 0.02)
        // 创建子弹材质
        let material = SimpleMaterial(color: .red, isMetallic: true)
        // 创建子弹实体
        let bulletEntity = ModelEntity(mesh: sphereShape, materials: [material])
        bulletAnchor.addChild(bulletEntity)
        arView.scene.addAnchor(bulletAnchor)
        // 子弹收集
        bullets[bulletId] = bulletEntity
        // 计算子弹目标位置
        let targetPos = pos + forward * 10
        // 自动移动中的变形和位移
        let transform = Transform(scale: bulletEntity.scale, rotation: bulletEntity.orientation, translation: targetPos)
        // 子弹移动
        bulletAnchor.move(to: transform, relativeTo: nil, duration: 1)
        // 1秒后消失
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            bulletEntity.removeFromParent()
            // 在子弹字典中找到元素并移除
            if let _ = self.bullets[bulletId] {
                self.bullets[bulletId] = nil
            }
            // 打印看一下子弹字典
            print("子弹字典\(self.bullets)")
        }
    }
}
