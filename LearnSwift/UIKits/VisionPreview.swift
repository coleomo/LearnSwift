//
//  VisionPreview.swift
//  LearnSwift
//
//  Created by song on 2025/12/5.
//

import AVFoundation
import SwiftUI


// UIView subclass to host the video preview layer
struct VisionPreview: UIViewRepresentable {
    // Create the video preview layer
    var session = AVCaptureSession()
    // 新增回调，用于将创建的layer传递给外部

    // Create the UIView and configure it with the video preview layer
    func makeUIView(context: Context) -> some UIView {
        let view = VideoPreview()
        view.videoPreviewLayer.session = session
        view.videoPreviewLayer.videoGravity = .resizeAspectFill
        return view
    }

    func updateUIView(_ uiView: UIViewType, context: Context) {}
}
