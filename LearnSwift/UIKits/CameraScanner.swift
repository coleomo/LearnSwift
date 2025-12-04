//
//  CameraScanner.swift
//  LearnSwift
//
//  Created by song on 2025/12/4.
//

import AVFoundation
import SwiftUI

// 构建相机扫描器，并显示在SwiftUI视图中
struct CameraScanner: UIViewRepresentable {
    // 使用binding将识别到的角点回传给父视图
    @Binding var corners: QRCorners

    func makeUIView(context: Context) -> some UIView {
        // 创建CameraView实例，自定义的UIView
        let cameraView = CameraPreView()
        // 设置代理
        cameraView.delegate = context.coordinator
        // 初始化相机配置，设置代理为Coordinator
        cameraView.setupCamera()
        // 让coordinator持有cameraView的弱引用,以便在代理方法中使用
        context.coordinator.cameraView = cameraView
        // 返回给SwiftUI使用
        return cameraView
    }

    func updateUIView(_ uiView: UIViewType, context: Context) {
        // 更新视图的逻辑
    }

    // 实现makeCoordinator方法，创建协调器实例
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }

    // 创建协调器，用于处理相机输出的代理方法
    class Coordinator: NSObject, AVCaptureMetadataOutputObjectsDelegate {
        // 持有父视图的引用
        var parent: CameraScanner
        // 持有CameraView的弱引用
        weak var cameraView: CameraPreView?

        init(parent: CameraScanner) {
            self.parent = parent
        }

        // 要实现这个函数，用于处理识别到的二维码，会被系统调用
        func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
            print("coordinator 识别到二维码")
            // 处理识别到的二维码逻辑，metadataObjects就是识别到的二维码数组
            if metadataObjects.isEmpty {
                // 没有检测到二维码，重置角点
                DispatchQueue.main.async {
                    self.parent.corners = QRCorners()
                }
                return
            }
            // 获取检测到的第一个二维码对象
            if let metadataObj = metadataObjects.first as? AVMetadataMachineReadableCodeObject {
                // 确保是二维码类型
                if metadataObj.type == .qr {
                    // 获取四个角点,这四个点坐标分别是左上、右上、右下、左下
                    let corners = metadataObj.corners
                    // 如果有四个角点，则打印它们的坐标
                    print("Coordinator QR Code Corners:")
                    // 打印四个角点坐标
                    for (index, corner) in corners.enumerated() {
                        print("Corner \(index + 1): \(corner)")
                    }
                    // 获取previewLayer进行坐标转换
                    guard let previewLayer = cameraView?.previewLayer,
                          let transformeObj = previewLayer.transformedMetadataObject(for: metadataObj) as? AVMetadataMachineReadableCodeObject
                    else {
                        return
                    }
                    // 获取转换后的角点
                    let transformCorners = transformeObj.corners
                    if transformCorners.count == 4 {
                        // 更新父视图的角点状态，注意顺序转换
                        parent.corners = QRCorners(
                            topLeft: transformCorners[0],
                            topRight: transformCorners[1],
                            bottomLeft: transformCorners[3],
                            bottomRight: transformCorners[2]
                        )
                    }
                }
            }
        }
    }
}
