//
//  CameraMan.swift
//  二维码距离相机管理类
//
//  Created by song on 2025/12/5.
//

import AVFoundation
import SwiftUI
import Vision

class CameraMan: NSObject, ObservableObject, AVCaptureVideoDataOutputSampleBufferDelegate {
    @Published var positionDesc = "未检测到二维码"
    @Published var session = AVCaptureSession()
    @Published var debugInfo: String = ""
    @Published var isScanning: Bool = false

    // 视频输出和序列处理器
    private let output = AVCaptureVideoDataOutput()
    // Vision序列请求处理器
    private let sequenceHandler = VNSequenceRequestHandler()

    // 检查相机权限并设置会话
    func checkPermissionAndSetup() {
        // 查看相机权限状态
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            print("已授权使用相机")
            setupCamera()
        case .notDetermined:
            print("请求相机使用权限")
        default:
            break
        }
    }

    // setupCamera
    func setupCamera() {
        print("设置相机")
        // 获取默认相机设备和输入
        guard let device = AVCaptureDevice.default(for: .video),
              let input = try? AVCaptureDeviceInput(device: device)
        else {
            return
        }
        // 配置会话
        session.beginConfiguration()
        if session.canAddInput(input) {
            session.addInput(input)
        }
        if session.canAddOutput(output) {
            output.setSampleBufferDelegate(self, queue: DispatchQueue(label: "videoQueue"))
            session.addOutput(output)
        }
        // 提交配置
        session.commitConfiguration()
        // 开始运行会话
        Task {
            self.session.startRunning()
        }
    }

    // 处理视频输出的代理方法
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        // 获取图像缓冲区
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            return
        }
        // 创建二维码检测请求
        let request = VNDetectBarcodesRequest { [weak self] request, _ in
            //
            guard let self = self else { return }
            // 处理检测结果
            guard let results = request.results as? [VNBarcodeObservation] else {
                return
            }
            // 查找第一个二维码结果
            guard let qrCode = results.first(where: { $0.symbology == .qr }) else {
                DispatchQueue.main.async {
                    self.positionDesc = "未检测到二维码"
                    self.isScanning = false
                    self.debugInfo = ""
                }
                return
            }
            // 获取二维码的边界框
            self.calculateDistance(observation: qrCode)
        }

        // 执行请求
        do {
            try sequenceHandler.perform([request], on: pixelBuffer)
        } catch {
            print("Vision请求执行失败: \(error)")
        }
    }

    // 计算二维码距离相机的估计距离
    func calculateDistance(observation: VNBarcodeObservation) {
        print("计算二维码距离")
        let tl = observation.topLeft
        let tr = observation.topRight
        let bl = observation.bottomLeft
        let br = observation.bottomRight

        // 计算四边的长度，使用欧几里得距离公式
        let leftHeight = distance(p1: tl, p2: bl)
        let rightHeight = distance(p1: tr, p2: br)
        let topWidth = distance(p1: tl, p2: tr)
        let bottomWidth = distance(p1: bl, p2: br)

        // 设定阈值，超过这个比例才认为是明显的倾斜, 15%的差异
        let threshold: CGFloat = 1.15
        var horizontalStatus = ""
        var verticalStatus = ""

        // 判断水平倾斜
        // 如果左边明显比右边长，说明相机距离二维码左边靠近，相机在左侧
        if leftHeight > rightHeight * threshold {
            horizontalStatus = "左侧"
        } else if rightHeight > leftHeight * threshold {
            horizontalStatus = "右侧"
        } else {
            horizontalStatus = "居中"
        }

        // 判断垂直倾斜
        // 注意：Vision坐标系Y轴向上。
        // 如果上边比下边宽，说明上边离相机近 -> 相机在上方
        if topWidth > bottomWidth * threshold {
            verticalStatus = "上方"
        } else if bottomWidth > topWidth * threshold {
            verticalStatus = "下方"
        } else {
            verticalStatus = "中间"
        }

        // 综合判断
        var finalResult = ""

        if horizontalStatus == "居中", verticalStatus == "中间" {
            finalResult = "正前方"
        } else {
            finalResult = "\(verticalStatus)\(horizontalStatus)"
        }

        // 更新ui
        DispatchQueue.main.async {
            self.positionDesc = finalResult
            self.isScanning = true
            self.debugInfo = String(format: "LeftHeight: %.2f, RightHeight: %.2f, TopWidth: %.2f, BottomWidth: %.2f", leftHeight, rightHeight, topWidth, bottomWidth)
        }
    }
}
