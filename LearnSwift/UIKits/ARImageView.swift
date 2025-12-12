//
//  ARImageView.swift
//  LearnSwift
//
//  Created by song on 2025/12/11.
//

import ARKit
import RealityKit
import SwiftUI

struct ImageARView: UIViewRepresentable {
    //
    func makeUIView(context: Context) -> ARView {
        let arView = ARView(frame: .zero)
        // 给协调器里面的arview赋值，用于绘制放置物体等
        context.coordinator.arView = arView
        // 配置 AR 图像识别
        let config = ARWorldTrackingConfiguration()
        // 开启水平面检测
        config.planeDetection = [.horizontal]
        // 加载 AR Resource Group
        if let referenceImages = ARReferenceImage.referenceImages(inGroupNamed: "AR Resources", bundle: nil) {
            config.detectionImages = referenceImages
            config.maximumNumberOfTrackedImages = 10
        } else {
            print("⚠️ 未加载到 AR Reference Images")
        }
        // config.debugDescription = [.]
        arView.session.run(config)
        arView.debugOptions = [.showWorldOrigin, .showFeaturePoints]
        arView.session.delegate = context.coordinator

        return arView
    }

    func updateUIView(_ uiView: ARView, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    // MARK: - Coordinator

    class Coordinator: NSObject, ARSessionDelegate {
        var parent: ImageARView
        weak var arView: ARView?

        init(_ parent: ImageARView) {
            self.parent = parent
        }

        // 图片第一次被识别
        func session(_ session: ARSession, didAdd anchors: [ARAnchor]) {
            for anchor in anchors {
                if let imageAnchor = anchor as? ARImageAnchor {
                    print("🎉 识别到图片：\(imageAnchor.referenceImage.name ?? "unknown")")
                    // 在图片上放3D物体
                    // place3DContent(on: imageAnchor, session: session)
                    // 添加水平面可视化
                    addPlaneVisual(anchor: imageAnchor, session: session)
                    // 图片中心点
                    imageCenterRed(anchor: imageAnchor, session: session)
                    // 从摄像头射线检测水平
                    // imagePlaneDetect(anchor: imageAnchor, session: session)
                }
                // else if let planeAnchor = anchor as? ARPlaneAnchor {
                //     // 识别到水平面
                //     addPlaneVisual(anchor: planeAnchor, session: session)
                // }
            }
        }

        // 图片中心点添加红色圆球
        func imageCenterRed(anchor: ARImageAnchor, session: ARSession) {
            // 图片的中心点就是图片锚点的原点0，0，0
            print("图片中心点添加红色圆球")
            if let arView = arView {
                let anchorEntity = AnchorEntity(anchor: anchor)
                // 创建圆形网格
                let mesh = MeshResource.generateSphere(radius: 0.01)
                // 创建金属材质
                let material = SimpleMaterial(color: .red, roughness: 0.0, isMetallic: true)
                // 创建实体
                let center = ModelEntity(mesh: mesh, materials: [material])
                center.position = [0, 0.01, 0]
                anchorEntity.addChild(center)
                arView.scene.addAnchor(anchorEntity)
            }
        }

        // 创建红色方块在图片中心
        func imageCenterBox(anchor: ARImageAnchor, session: ARSession) {
            print("创建红色方块在图片中心")
            if let arView = arView {
                // mesh是网格
                let mesh = MeshResource.generateBox(size: 0.02)
                // matrial 是素材材质
                let material = SimpleMaterial(color: .red, roughness: 0.5, isMetallic: true)
                // 红色方块实例
                let boxEntity = ModelEntity(mesh: mesh, materials: [material])
                // 将红色方块添加到中心位置,并且在y轴向上
                boxEntity.position = [0, 0.01, 0]
                // 创建碰撞
                let collisionShape = ShapeResource.generateBox(size: [0.02, 0.02, 0.02])
                // 添加碰撞组件：可以用多个碰撞形状
                boxEntity.components.set(CollisionComponent(shapes: [collisionShape]))
                // 创建锚点实例
                let anchorEntity = AnchorEntity(anchor: anchor)
                // 锚点添加模型
                anchorEntity.addChild(boxEntity)
                // 视图添加锚点
                arView.scene.addAnchor(anchorEntity)
            }
        }

        // 射线检测图片所在的水平面
        func imagePlaneDetect(anchor: ARImageAnchor, session: ARSession) {
            let position = anchor.transform.columns.3
            print("图片中心点坐标：\(position)")
            if let arView = arView {
                let results = arView.raycast(from: CGPoint(x: arView.bounds.midX, y: arView.bounds.minY), allowing: .estimatedPlane, alignment: .horizontal)
                if let firshHit = results.first {
                    print("找到图片所在的水平面位置：\(firshHit.worldTransform.columns.3)")
                } else {
                    print("没有找到图片的水平面")
                }
            } else {
                print("arView != arView")
            }
        }

        // 在图片上放一个 3D 物体
        func place3DContent(on imageAnchor: ARImageAnchor, session: ARSession) {
            guard let arView = arView else { return }

            // 添加一个 AnchorEntity
            let anchorEntity = AnchorEntity(anchor: imageAnchor)

            // 放一个 3D 盒子
            let box = ModelEntity(
                mesh: .generateBox(size: [0.05, 0.05, 0.05]),
                materials: [SimpleMaterial(color: .red, isMetallic: false)]
            )

            // 把盒子放到图片上方
            box.position = [0, 0.03, 0]
            // 锚点添加盒子模型
            anchorEntity.addChild(box)
            // 视图添加锚点
            arView.scene.addAnchor(anchorEntity)
        }

        // 添加水平面可视化
        func addPlaneVisual(anchor: ARImageAnchor, session: ARSession) {
            guard let arView = arView ?? nil else {
                print("返回----")
                return
            }
            print("开始添加水平面")
            // let size = anchor.planeExtent
            let plane = MeshResource.generatePlane(width: 0.2, depth: 0.3)
            let material = SimpleMaterial(color: UIColor.blue.withAlphaComponent(0.7), isMetallic: true)

            let model = ModelEntity(mesh: plane, materials: [material])
            // 拿到图片的中心点坐标
            // let position = anchor.transform.columns.3
            model.position = SIMD3(0, 0, 0)

            let anchorEntity = AnchorEntity(anchor: anchor)
            anchorEntity.addChild(model)
            arView.scene.addAnchor(anchorEntity)
            print("添加可视化平面")
        }
    }
}
