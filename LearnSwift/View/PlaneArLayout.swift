//
//  PlaneArLayout.swift
//  LearnSwift
//
//  Created by song on 2025/12/11.
//

import SwiftUI

struct PlaneArLayout: View {
    @State var isPlaneDetected = false
    @State var planeInfo = "扫描平面中..."

    var body: some View {
        ZStack {
            PlaneArview(isPlaneDetected: $isPlaneDetected, planeInfo: $planeInfo).ignoresSafeArea(.all)

            VStack {
                Text("平面检测")
                    .font(.largeTitle)
                    .foregroundStyle(.white)
                    .padding()
                    .background(Color.black.opacity(0.7))
                    .cornerRadius(10)
                Spacer()
                VStack(spacing: 15) {
                    Text(planeInfo)
                        .foregroundStyle(.white)
                        .padding()
                        .background(isPlaneDetected ? Color.green : Color.orange)
                        .cornerRadius(8)
                    if isPlaneDetected {
                        Text("点击放置物体")
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(8)
                    }
                }
                .padding(.bottom, 50)
            }
        }
    }
}
