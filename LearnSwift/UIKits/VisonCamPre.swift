//
//  VisonCamPre.swift
//  LearnSwift
//
//  Created by song on 2025/12/5.
//

import AVFoundation
import SwiftUI
import UIKit

struct VisonCamPre: UIViewRepresentable {
    
    
    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        view.backgroundColor = .black

        let previewLayer = AVCaptureVideoPreviewLayer()
        previewLayer.videoGravity = .resizeAspectFill
        previewLayer.frame = view.bounds
        view.layer.addSublayer(previewLayer)
        return view
    }

    func updateUIView(_ uiView: UIViewType, context: Context) {
        // 更新视图的逻辑
    }
}
