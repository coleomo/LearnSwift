//
//  Comm.swift
//  LearnSwift
//
//  Created by song on 2025/12/4.
//

import SwiftUI

/// 计算以 'vertex' 为顶点的角，由 'p1' 和 'p2' 形成的角度（以度为单位）。
func calculateAngle(p1: CGPoint, vertex: CGPoint, p2: CGPoint) -> Double {
    // 1. 计算向量
    // 向量 u: 从顶点指向 p1
    let vectorU = CGVector(dx: p1.x - vertex.x, dy: p1.y - vertex.y)
    // 向量 v: 从顶点指向 p2
    let vectorV = CGVector(dx: p2.x - vertex.x, dy: p2.y - vertex.y)

    // 2. 计算点积 (Dot Product)
    let dotProduct = Double(vectorU.dx * vectorV.dx + vectorU.dy * vectorV.dy)

    // 3. 计算模长 (Magnitude)
    let magnitudeU = sqrt(Double(vectorU.dx * vectorU.dx + vectorU.dy * vectorU.dy))
    let magnitudeV = sqrt(Double(vectorV.dx * vectorV.dx + vectorV.dy * vectorV.dy))

    // 避免除以零
    guard magnitudeU > 0 && magnitudeV > 0 else { return 0.0 }

    // 4. 计算 Cosine 值 (并限制在 [-1, 1] 以避免浮点误差导致的 acos(>1) 错误)
    let cosTheta = dotProduct / (magnitudeU * magnitudeV)
    let clampedCosTheta = max(-1.0, min(1.0, cosTheta))

    // 5. 计算角度 (以弧度为单位)
    let radians = acos(clampedCosTheta)

    // 6. 转换为度数
    let degrees = radians * 180.0 / Double.pi

    return degrees
}

// 计算两点距离
func distance(p1: CGPoint, p2: CGPoint) -> CGFloat {
    // 计算两点之间的欧几里得距离
    return sqrt(pow(p1.x - p2.x, 2) + pow(p1.y - p2.y, 2))
}
