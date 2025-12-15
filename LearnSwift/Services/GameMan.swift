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
    // 和服务器连接状态
    @Published var connectState: ConnectState = .disconnected
    // 子弹集合，收集子弹id和实体，空字典[:]
    @Published var bullets: [String: Entity] = [:]
    // 收集碰撞事件的订阅，否则会不知道碰撞事件
    private var cancellables = Set<AnyCancellable>()

    // Arview 视图
    private var arView: ARView?

    // 配置arview
    func setupArView(_ arView: ARView) {
        self.arView = arView
        // 添加碰撞检测事件监听订阅消息
        self.arView?.scene.subscribe(to: CollisionEvents.Began.self) { [weak self] event in
            // 处理碰撞事件
            self?.onCollision(event)
        }.store(in: &cancellables)
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
        // 创建碰撞形状
        let collisionShape = ShapeResource.generateSphere(radius: 0.02)
        // 创建子弹实体
        let bulletEntity = ModelEntity(mesh: sphereShape, materials: [material])
        // 设置碰撞组件
        bulletEntity.components.set(CollisionComponent(shapes: [collisionShape]))
        bulletEntity.name = "bullet"
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
            // 从父视图中移除自己
            bulletEntity.removeFromParent()
            // 在子弹字典中找到元素并移除
            if let _ = self.bullets[bulletId] {
                self.bullets[bulletId] = nil
            }
            // 打印看一下子弹字典
            print("子弹字典\(self.bullets)")
        }
    }

    // 监听碰撞事件
    func onCollision(_ event: CollisionEvents.Began) {
        print("碰撞事件")
        // 获取碰撞的两个实例
        let entityA = event.entityA
        let entityB = event.entityB
        // 判断是不是子弹和敌人碰撞
        if entityA.name != entityB.name {
            print("两个碰撞体不一样")
            // 找到子弹实体
            score += 10
            // 移除子弹和敌人
            entityA.removeFromParent()
            entityB.removeFromParent()
        }
    }
}
