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
        // 配置 AR 会话，世界跟踪配置，检测平面，启用协作功能，支持人物分割深度
        let config = ARWorldTrackingConfiguration()
        // 检测平面，水平和垂直
        config.planeDetection = [.horizontal]
        // 启用协作功能，支持多设备共享AR世界，需要网络连接，需要服务器支持，需要网络管理器支持
        config.isCollaborationEnabled = true
        // 运行 AR 会话
        arView.session.run(config)
        arView.debugOptions = [.showWorldOrigin, .showFeaturePoints]
        return arView
    }

    func updateUIView(_ uiView: UIViewType, context: Context) {
        print("updateUiview")
    }
}
