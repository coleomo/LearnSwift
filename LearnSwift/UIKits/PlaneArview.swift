//
//  PlaneArview.swift
//  LearnSwift
//
//  Created by song on 2025/12/11.
//

import ARKit
import AVFoundation
import Combine
import RealityKit
import SwiftUI
import Vision

struct PlaneArview: UIViewRepresentable {
    @Binding var isPlaneDetected: Bool
    @Binding var planeInfo: String

    // 创建 AR 视图
    func makeUIView(context: Context) -> ARView {
        // 创建 AR 视图
        let arView = ARView(frame: UIScreen.main.bounds)
        context.coordinator.arView = arView
        // 配置 AR 会话，世界跟踪配置，检测平面，启用协作功能，支持人物分割深度
        let config = ARWorldTrackingConfiguration()
        // 检测平面，水平和垂直
        config.planeDetection = [.horizontal]
        // 启用协作功能，支持多设备共享AR世界，需要网络连接，需要服务器支持，需要网络管理器支持
        config.isCollaborationEnabled = true
        // 运行 AR 会话
        arView.session.run(config)
        arView.debugOptions = [.showWorldOrigin, .showFeaturePoints]
        // 设置委托
        arView.session.delegate = context.coordinator
        // 添加手势
        let tapGesture = UITapGestureRecognizer(target: context.coordinator,
                                                action: #selector(Coordinator.handleTap))
        arView.addGestureRecognizer(tapGesture)
        return arView
    }

    func updateUIView(_ uiView: UIViewType, context: Context) {
        print("updateUiview")
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, ARSessionDelegate {
        var parent: PlaneArview
        // 在外部赋值，在内部使用
        weak var arView: ARView?
        
        // 初始化
        init(_ parent: PlaneArview) {
            self.parent = parent
        }
        
        // 检测到平面时调用：自动检测平面
        func session(_ session: ARSession, didAdd anchors: [ARAnchor]) {
            for anchor in anchors {
                if let planeAnchor = anchor as? ARPlaneAnchor {
                    // 添加可视化的平面
                    addPlaneVisual(anchor: planeAnchor, session: session)
                    // 更新ui
                    DispatchQueue.main.async {
                        self.parent.isPlaneDetected = true
                        let size = String(format: "%.2f x %.2f米",
                                          planeAnchor.planeExtent.width,
                                          planeAnchor.planeExtent.height)
                        self.parent.planeInfo = "检测到平面 - 大小: \(size)"
                    }
                }
            }
        }
        
        // 添加水平面可视化
        func addPlaneVisual(anchor: ARPlaneAnchor, session: ARSession) {
            guard let arView = arView ?? nil else {
                print("返回----")
                return
            }
            print("开始添加水平面")
            let size = anchor.planeExtent
            let plane = MeshResource.generatePlane(width: size.width, depth: size.height)
            let material = SimpleMaterial(color: .blue, isMetallic: true)
            
            let model = ModelEntity(mesh: plane, materials: [material])
            model.position = SIMD3(anchor.center.x, 0, anchor.center.z)
            
            let anchorEntity = AnchorEntity(anchor: anchor)
            anchorEntity.addChild(model)
            arView.scene.addAnchor(anchorEntity)
            print("添加可视化平面")
        }
        
        // 点击添加物体到平面上
        @objc func handleTap(_ gesture: UITapGestureRecognizer) {
            guard let arView = gesture.view as? ARView else { return }
            // 手势点击在arview中的位置
            let location = gesture.location(in: arView)
            
            // 检测点击位置：通过射线检测
            let results = arView.raycast(from: location,
                                         allowing: .estimatedPlane,
                                         alignment: .any)
            
            if let pos = results.first {
                print("first pos \(pos)")
                // 在点击位置放置物体
                let sphere = ModelEntity(mesh: .generateSphere(radius: 0.05),
                                         materials: [SimpleMaterial(color: .blue,
                                                                    isMetallic: true)])
                
                let anchor = AnchorEntity(plane: .horizontal)
                anchor.addChild(sphere)
                arView.scene.addAnchor(anchor)
            }
        }
    }
}
