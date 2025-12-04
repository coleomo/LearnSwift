//
//  CameraSet.swift
//  LearnSwift
//
//  Created by song on 2025/12/4.
//

import AVFoundation
import UIKit

// 自定义一个CameraView 来持有AVCaptureSession和PreviewLayer，并实现AVCaptureMetadataOutputObjectsDelegate协议，
// 用于处理二维码识别结果，并显示相机预览
class CameraPreView: UIView {
    // 相机会话和预览图层
    var session: AVCaptureSession!
    // 相机预览图层
    var previewLayer: AVCaptureVideoPreviewLayer!
    // 相机元数据输出代理
    weak var delegate: AVCaptureMetadataOutputObjectsDelegate?

    // 初始化方法
    override init(frame: CGRect) {
        super.init(frame: frame)
        // ❌ 问题1：这里 bounds 可能是错误的
        print("init 中的 bounds: \(bounds)")
        // 可能输出：init 中的 bounds: (0.0, 0.0, 0.0, 0.0)
        // ❌ 问题2：frame 可能还没设置
        print("init 中的 frame: \(frame)")
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // 一定要在 layoutSubviews 中设置 bounds
    override func layoutSubviews() {
        super.layoutSubviews()
        print("layoutSubviews 中的 bounds: \(bounds)")
        // 给预览层设置正确的帧大小
        previewLayer.frame = bounds // 这行必须要有！
    }

    // 设置相机
    func setupCamera() {
        // 配置相机会话和预览图层的逻辑
        let session = AVCaptureSession()
        // 获取默认的视频捕捉设备
        guard let device = AVCaptureDevice.default(for: .video) else {
            return
        }
        // 创建输入设备
        guard let input = try? AVCaptureDeviceInput(device: device) else { return }
        // 添加输入设备到会话
        if session.canAddInput(input) {
            session.addInput(input)
        }
        // 创建元数据输出
        let output = AVCaptureMetadataOutput()
        // 添加输出设备到会话
        if session.canAddOutput(output) {
            session.addOutput(output)
            // 设置元数据输出代理
            output.setMetadataObjectsDelegate(delegate, queue: DispatchQueue.main)
            // 设置识别类型为二维码，可以为多个
            output.metadataObjectTypes = [.qr]
        }
        // 创建预览图层
        let previewLayer = AVCaptureVideoPreviewLayer(session: session)
        // 设置预览图层的填充模式
        previewLayer.videoGravity = .resizeAspectFill
        // 设置预览图层的帧大小
        // previewLayer.frame = bounds
        print("setupCamera 中的 bounds: \(bounds)")
        // 将预览图层添加到视图的图层中
        layer.addSublayer(previewLayer)
        // 启动会话
        self.session = session
        self.previewLayer = previewLayer
        // 启动相机会话，这么做会不会阻塞UI？
        DispatchQueue.global(qos: .background).async {
            session.startRunning()
        }
    }
}
