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
    var session = AVCaptureSession()

    // Create the UIView and configure it with the video preview layer
    func makeUIView(context: Context) -> some UIView {
        let view = VideoPreview()
        view.videoPreviewLayer.session = session
        view.videoPreviewLayer.videoGravity = .resizeAspectFill
        return view
    }

    func updateUIView(_ uiView: UIViewType, context: Context) {}
}
