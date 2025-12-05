//
//  VideoPreview.swift
//  LearnSwift
//
//  Created by song on 2025/12/5.
//

import AVFoundation
import SwiftUI


// 自定义视频预览视图，使用 AVCaptureVideoPreviewLayer 作为其底层图层
class VideoPreview: UIView {
    // 指定图层类为 AVCaptureVideoPreviewLayer
    override class var layerClass: AnyClass {
        return AVCaptureVideoPreviewLayer.self
    }

    // 方便访问底层的 AVCaptureVideoPreviewLayer
    var videoPreviewLayer: AVCaptureVideoPreviewLayer {
        return layer as! AVCaptureVideoPreviewLayer
    }
}
