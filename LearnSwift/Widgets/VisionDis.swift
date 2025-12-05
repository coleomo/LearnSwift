//
//  VisionDis.swift
//  LearnSwift
//
//  Created by song on 2025/12/5.
//

import SwiftUI

struct VisionDis: View {
    @StateObject private var scannerModel = CameraMan()

    // 距离二维码的位置
    var body: some View {
        ZStack {
            // 相机预览层
            VisionPreview(session: scannerModel.session)

            // 信息覆盖层
            VStack {
                Spacer()
                VStack(spacing: 15) {
                    Text(scannerModel.positionDesc)
                        .font(.system(size: 40, weight: .bold))
                        .foregroundStyle(.white)
                        .shadow(radius: 2)
                }
            }
        }
        .edgesIgnoringSafeArea(.all)
        .onAppear {
            scannerModel.checkPermissionAndSetup()
        }
    }
}
