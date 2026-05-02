//
//  SkeletonView.swift
//  ClaroTest
//
//  Created by Luis Santana on 1/5/26.
//

import SwiftUI
struct SkeletonView: View {
    
    @State private var shimmer = false
    
    var body: some View {
        RoundedRectangle(cornerRadius: 16)
            .fill(
                LinearGradient(
                    colors: [
                        Color.gray.opacity(0.3),
                        Color.gray.opacity(0.1),
                        Color.gray.opacity(0.3)
                    ],
                    startPoint: shimmer ? .leading : .trailing,
                    endPoint: shimmer ? .trailing : .leading
                )
            )
            .onAppear {
                withAnimation(.linear(duration: 1.2).repeatForever(autoreverses: false)) {
                    shimmer.toggle()
                }
            }
    }
}
