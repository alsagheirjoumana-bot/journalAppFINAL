import SwiftUI

// ===== Liquid Glass (tuned to your mock) =====

/// Shiny capsule for the top-right Sort + Plus cluster
struct GlassPill: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(.ultraThinMaterial) // live blur
            .clipShape(Capsule())

            // soft outer rim
            .overlay(
                Capsule()
                    .strokeBorder(.white.opacity(0.10), lineWidth: 1)
                    .blendMode(.plusLighter)
                    .allowsHitTesting(false)
            )

            // inner highlight band (top → mid fade)
            .overlay(
                Capsule()
                    .inset(by: 1.5)
                    .stroke(
                        LinearGradient(
                            colors: [.white.opacity(0.28), .white.opacity(0.06), .clear],
                            startPoint: .top, endPoint: .bottom
                        ),
                        lineWidth: 1
                    )
                    .blendMode(.screen)
                    .allowsHitTesting(false)
            )

            // subtle depth
            .shadow(color: .black.opacity(0.30), radius: 18, x: 0, y: 10)
    }
}
extension View { func glassPill() -> some View { modifier(GlassPill()) } }

/// Capsule field for the bottom search bar (darker, with rim + sheen)
struct GlassCapsuleField: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(.ultraThinMaterial)
            .clipShape(Capsule())

            // soft rim
            .overlay(
                Capsule()
                    .strokeBorder(.white.opacity(0.10), lineWidth: 1)
                    .blendMode(.plusLighter)
                    .allowsHitTesting(false)
            )

            // top sheen
            .overlay(
                Capsule()
                    .inset(by: 1.5)
                    .stroke(
                        LinearGradient(
                            colors: [.white.opacity(0.22), .white.opacity(0.04), .clear],
                            startPoint: .top, endPoint: .bottom
                        ),
                        lineWidth: 1
                    )
                    .blendMode(.screen)
                    .allowsHitTesting(false)
            )

            .shadow(color: .black.opacity(0.25), radius: 16, x: 0, y: 8)
    }
}
extension View { func glassCapsuleField() -> some View { modifier(GlassCapsuleField()) } }

/// (Optional) Card style if you want to reuse for other places
struct GlassCard: ViewModifier {
    var corner: CGFloat = 16
    func body(content: Content) -> some View {
        content
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: corner, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: corner, style: .continuous)
                    .stroke(.white.opacity(0.06), lineWidth: 1)
                    .blendMode(.plusLighter)
                    .allowsHitTesting(false)
            )
    }
}
extension View { func glassCard(corner: CGFloat = 16) -> some View { modifier(GlassCard(corner: corner)) } }
