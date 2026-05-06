//
//  ShimmerOverlayView.swift
//  SportFolio
//

import UIKit

class ShimmerOverlayView: UIView {

    
    private let shimmerGradient = CAGradientLayer()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor(red: 0.95, green: 0.96, blue: 0.98, alpha: 1)
        buildSkeleton()
    }

    required init?(coder: NSCoder) { fatalError() }

   
    private func buildSkeleton() {
        var yOffset: CGFloat = 16


        addSkeleton(x: 16, y: yOffset, width: 200, height: 18, cornerRadius: 9)
        yOffset += 34
        let cardWidth = UIScreen.main.bounds.width * 0.88
        addSkeleton(x: 16, y: yOffset, width: cardWidth, height: 196, cornerRadius: 20)
        yOffset += 196 + 20
        addSkeleton(x: 16, y: yOffset, width: 180, height: 18, cornerRadius: 9)
        yOffset += 34

        for i in 0..<3 {
            let rowY = yOffset + CGFloat(i) * (80 + 10)
            addSkeleton(x: 16, y: rowY,
                        width: UIScreen.main.bounds.width - 32, height: 78,
                        cornerRadius: 16)
        }
        yOffset += 3 * 90 + 16

        addSkeleton(x: 16, y: yOffset, width: 160, height: 18, cornerRadius: 9)
        yOffset += 28
        addSkeleton(x: 16, y: yOffset,
                    width: UIScreen.main.bounds.width - 32, height: 32,
                    cornerRadius: 10)
        yOffset += 48

      
        for i in 0..<5 {
            let itemX = 16 + CGFloat(i) * (116 + 8)
        
            addSkeleton(x: itemX + 8, y: yOffset, width: 80, height: 80, cornerRadius: 40)
            addSkeleton(x: itemX, y: yOffset + 88, width: 96, height: 12, cornerRadius: 6)
        }
    }

    @discardableResult
    private func addSkeleton(x: CGFloat, y: CGFloat,
                             width: CGFloat, height: CGFloat,
                             cornerRadius: CGFloat) -> UIView {
        let v = UIView(frame: CGRect(x: x, y: y, width: width, height: height))
        v.backgroundColor = UIColor(white: 0.5, alpha: 1)
        v.layer.cornerRadius = cornerRadius
        v.layer.masksToBounds = true
        addSubview(v)
        return v
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        startShimmer()
    }

    func startShimmer() {
        shimmerGradient.removeFromSuperlayer()

        let light = UIColor.white.withAlphaComponent(0.75).cgColor
        let base  = UIColor(white: 0.87, alpha: 1).cgColor
        shimmerGradient.colors   = [base, light, base]
        shimmerGradient.locations = [0.0, 0.5, 1.0]
        shimmerGradient.startPoint = CGPoint(x: 0, y: 0.5)
        shimmerGradient.endPoint   = CGPoint(x: 1, y: 0.5)
        shimmerGradient.frame = CGRect(
            x: -bounds.width, y: 0,
            width: bounds.width * 3, height: bounds.height
        )
        layer.addSublayer(shimmerGradient)

        let animation = CABasicAnimation(keyPath: "transform.translation.x")
        animation.fromValue  = -bounds.width
        animation.toValue    = bounds.width
        animation.duration   = 1.3
        animation.repeatCount = .infinity
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        shimmerGradient.add(animation, forKey: "shimmer")
    }

    func stopShimmer() {
        shimmerGradient.removeAllAnimations()
        shimmerGradient.removeFromSuperlayer()
    }
}
