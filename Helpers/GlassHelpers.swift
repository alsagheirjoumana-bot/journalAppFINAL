//
//  GlassHelpers.swift
//  journalApp88
//
//  Created by Joumana Alsagheir on 22/10/2025.
//

import SwiftUI

// ===== Liquid Glass Styles =====

/// Rounded capsule used for the top-right toolbar (Sort + Plus)
struct GlassPill: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(.vertical, 10)
            .padding(.horizontal, 14)
            .background(.ultraThinMaterial)                         // blur + vibrancy
            .clipShape(Capsule())
            .overlay(Capsule().stroke(.white.opacity(0.08), lineWidth: 1)) // soft edge
            .shadow(color: .black.opacity(0.35), radius: 18, x: 0, y: 10)  // halo
            .overlay(                                                     // faint inner shine
                Capsule()
                    .fill(LinearGradient(colors: [.white.opacity(0.12), .clear],
                                           startPoint: .top, endPoint: .center))
                    .blendMode(.plusLighter)
                    .allowsHitTesting(false)
            )
    }
}
extension View { func glassPill() -> some View { modifier(GlassPill()) } }

/// Capsule field used for the bottom search bar
struct GlassCapsuleField: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(.vertical, 12)
            .padding(.horizontal, 14)
            .background(.ultraThinMaterial)
            .clipShape(Capsule())
            .overlay(Capsule().stroke(.white.opacity(0.08), lineWidth: 1))
            .shadow(color: .black.opacity(0.25), radius: 16, x: 0, y: 8)
    }
}
extension View { func glassCapsuleField() -> some View { modifier(GlassCapsuleField()) } }

/// Card style (for entry rows later)
struct GlassCard: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            .overlay(RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .stroke(.white.opacity(0.06), lineWidth: 1))
    }
}
extension View { func glassCard() -> some View { modifier(GlassCard()) } }
