//
//  VisionPreview.swift
//  LearnSwift
//
//  Created by song on 2025/12/5.
//

import AVFoundation
import SwiftUI

// UIView 子类，用于显示摄像头视频预览
struct VisionPreview: UIViewRepresentable {
    // Create the video preview layer
    var session = AVCaptureSession()
    // 新增回调，用于将创建的layer传递给外部

    // 创建并配置 UIView
    func makeUIView(context: Context) -> some UIView {
        // 创建自定义的 VideoPreview 视图
        let view = VideoPreview()
        // 将捕获会话关联到视频预览图层
        view.videoPreviewLayer.session = session
        // 设置视频填充模式
        view.videoPreviewLayer.videoGravity = .resizeAspectFill
        return view
    }

    func updateUIView(_ uiView: UIViewType, context: Context) {}
}
