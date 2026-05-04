//
//  splahView.swift
//  SportFolio
//
//  Created by JETSMobileLabMini2 on 04/05/2026.
//

import UIKit
import Lottie

 
final class SplashViewController: UIViewController {
 
    private let presenter = SplashPresenter()

    
    private let gradientLayer = CAGradientLayer()

 
    private let glowView: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.alpha = 0
        return v
    }()
    private let glowLayer = CAGradientLayer()

 
    private var particleLayers: [CAShapeLayer] = []
    private let particleCount = 22

 
    private let cardView: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = UIColor.white.withAlphaComponent(0.07)
        v.layer.cornerRadius = 36
        v.clipsToBounds = false
        return v
    }()

    private let cardBorderLayer: CAShapeLayer = {
        let l = CAShapeLayer()
        l.lineWidth  = 1.5
        l.fillColor  = UIColor.clear.cgColor
        l.strokeColor = UIColor.white.withAlphaComponent(0.18).cgColor
        return l
    }()

    private let innerBlurView: UIVisualEffectView = {
        let blur = UIBlurEffect(style: .systemUltraThinMaterialDark)
        let v = UIVisualEffectView(effect: blur)
        v.translatesAutoresizingMaskIntoConstraints = false
        v.layer.cornerRadius = 36
        v.clipsToBounds = true
        return v
    }()

 
    private var animationView: LottieAnimationView!
 
    private let logoStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.alignment = .center
        sv.spacing = 6
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.alpha = 0
        return sv
    }()

    private let appNameLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "SportFolio"
        if let descriptor = UIFontDescriptor.preferredFontDescriptor(withTextStyle: .largeTitle)
            .withDesign(.rounded) {
            lbl.font = UIFont(descriptor: descriptor.withSymbolicTraits(.traitBold) ?? descriptor,
                              size: 40)
        } else {
            lbl.font = UIFont.systemFont(ofSize: 40, weight: .heavy)
        }
        lbl.textColor = .white
        lbl.textAlignment = .center
        return lbl
    }()

    private let taglineLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Your Sports Universe"
        lbl.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        lbl.textColor = UIColor.white.withAlphaComponent(0.65)
        lbl.textAlignment = .center
        lbl.letterSpacing(1.5)
        return lbl
    }()

    private let loadingDots = PulsingDotsView()

 

    override func viewDidLoad() {
        super.viewDidLoad()
        setupGradientBackground()
        setupGlow()
        setupParticles()
        setupCard()
        setupLottieAnimation()
        setupLabels()
        setupLoadingDots()
        animateIn()
        presenter.attachView(self)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        gradientLayer.frame = view.bounds

        let glowFrame = glowView.bounds
        glowLayer.frame = glowFrame

     
        let path = UIBezierPath(roundedRect: cardView.bounds,
                                cornerRadius: cardView.layer.cornerRadius)
        cardBorderLayer.path = path.cgPath
        cardBorderLayer.frame = cardView.bounds
    }

 
    private func setupGradientBackground() {
        gradientLayer.colors = gradientColors(for: .soccer)
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradientLayer.endPoint   = CGPoint(x: 1.0, y: 1.0)
        view.layer.insertSublayer(gradientLayer, at: 0)
    }

    private func setupGlow() {
        view.addSubview(glowView)
        NSLayoutConstraint.activate([
            glowView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            glowView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            glowView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1.1),
            glowView.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1.1)
        ])

        glowLayer.type = .radial
        glowLayer.colors = [
            UIColor(red: 0.20, green: 0.85, blue: 0.30, alpha: 0.20).cgColor,
            UIColor.clear.cgColor
        ]
        glowLayer.startPoint = CGPoint(x: 0.5, y: 0.5)
        glowLayer.endPoint   = CGPoint(x: 1.0, y: 1.0)
        glowView.layer.addSublayer(glowLayer)

        UIView.animate(withDuration: 1.2, delay: 0.5, options: .curveEaseIn) {
            self.glowView.alpha = 1
        }
    }

    private func setupParticles() {
        for _ in 0..<particleCount {
            let particle = CAShapeLayer()
            let size = CGFloat.random(in: 2...5)
            particle.path = UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: size, height: size)).cgPath
            particle.fillColor = UIColor.white.withAlphaComponent(CGFloat.random(in: 0.06...0.22)).cgColor
            view.layer.addSublayer(particle)
            particleLayers.append(particle)
            animateParticle(particle)
        }
    }

    private func animateParticle(_ layer: CAShapeLayer) {
        let screenW = UIScreen.main.bounds.width
        let screenH = UIScreen.main.bounds.height
        let startX  = CGFloat.random(in: 0...screenW)
        let startY  = CGFloat.random(in: 0...screenH)
        let endY    = startY - CGFloat.random(in: 80...250)
        let duration = Double.random(in: 4...9)

        layer.position = CGPoint(x: startX, y: startY)
        layer.opacity  = 0

        let move           = CABasicAnimation(keyPath: "position.y")
        move.fromValue     = startY
        move.toValue       = endY
        move.duration      = duration
        move.beginTime     = CACurrentMediaTime() + Double.random(in: 0...4)
        move.fillMode      = .forwards
        move.isRemovedOnCompletion = false

        let fade           = CAKeyframeAnimation(keyPath: "opacity")
        fade.values        = [0, 0.7, 0.7, 0]
        fade.keyTimes      = [0, 0.15, 0.75, 1]
        fade.duration      = duration
        fade.beginTime     = move.beginTime
        fade.fillMode      = .forwards
        fade.isRemovedOnCompletion = false

        let group          = CAAnimationGroup()
        group.animations   = [move, fade]
        group.duration     = duration
        group.beginTime    = move.beginTime
        group.repeatCount  = .infinity
        group.fillMode     = .forwards
        group.isRemovedOnCompletion = false

        layer.add(group, forKey: "float")
    }

    private func setupCard() {
   
        view.addSubview(cardView)
        NSLayoutConstraint.activate([
            cardView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            cardView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 20),
            cardView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.88),
            cardView.heightAnchor.constraint(equalTo: cardView.widthAnchor, multiplier: 1.0)
        ])
        cardView.layer.shadowColor   = UIColor.black.cgColor
        cardView.layer.shadowOpacity = 0.45
        cardView.layer.shadowOffset  = CGSize(width: 0, height: 16)
        cardView.layer.shadowRadius  = 40

       
        cardView.addSubview(innerBlurView)
        NSLayoutConstraint.activate([
            innerBlurView.topAnchor.constraint(equalTo: cardView.topAnchor),
            innerBlurView.bottomAnchor.constraint(equalTo: cardView.bottomAnchor),
            innerBlurView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor),
            innerBlurView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor)
        ])

     
        cardView.layer.addSublayer(cardBorderLayer)
    }

    private func setupLottieAnimation() {
        animationView = LottieAnimationView(name: "splash")
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode    = .playOnce
        animationView.backgroundBehavior = .pauseAndRestore
        animationView.translatesAutoresizingMaskIntoConstraints = false
        animationView.layer.cornerRadius = 32
        animationView.clipsToBounds      = true

        innerBlurView.contentView.addSubview(animationView)
        NSLayoutConstraint.activate([
            animationView.topAnchor.constraint(equalTo: innerBlurView.topAnchor, constant: 8),
            animationView.bottomAnchor.constraint(equalTo: innerBlurView.bottomAnchor, constant: -8),
            animationView.leadingAnchor.constraint(equalTo: innerBlurView.leadingAnchor, constant: 8),
            animationView.trailingAnchor.constraint(equalTo: innerBlurView.trailingAnchor, constant: -8)
        ])

        animationView.play()
    }

    private func setupLabels() {
        logoStackView.addArrangedSubview(appNameLabel)
        logoStackView.addArrangedSubview(taglineLabel)
        view.addSubview(logoStackView)

        NSLayoutConstraint.activate([
            logoStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoStackView.bottomAnchor.constraint(equalTo: cardView.topAnchor, constant: -28)
        ])
    }

    private func setupLoadingDots() {
        loadingDots.translatesAutoresizingMaskIntoConstraints = false
        loadingDots.alpha = 0
        view.addSubview(loadingDots)
        NSLayoutConstraint.activate([
            loadingDots.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingDots.topAnchor.constraint(equalTo: cardView.bottomAnchor, constant: 32),
            loadingDots.widthAnchor.constraint(equalToConstant: 60),
            loadingDots.heightAnchor.constraint(equalToConstant: 12)
        ])
    }

 
    private func animateIn() {
        cardView.transform   = CGAffineTransform(scaleX: 0.82, y: 0.82)
        cardView.alpha       = 0
        logoStackView.transform = CGAffineTransform(translationX: 0, y: 20)

        UIView.animate(withDuration: 0.9, delay: 0.2,
                       usingSpringWithDamping: 0.72,
                       initialSpringVelocity: 0.4,
                       options: .curveEaseOut) {
            self.cardView.transform = .identity
            self.cardView.alpha     = 1
        }

        UIView.animate(withDuration: 0.8, delay: 0.5, options: .curveEaseOut) {
            self.logoStackView.alpha     = 1
            self.logoStackView.transform = .identity
        }

        UIView.animate(withDuration: 0.6, delay: 1.0, options: .curveEaseIn) {
            self.loadingDots.alpha = 1
        }
    }
     private func gradientColors(for sport: SplashSport) -> [CGColor] {
        let (top, bottom) = sport.gradientColors
        return [top.cgColor, bottom.cgColor]
    }
}
 
extension SplashViewController: SplashViewProtocol {

    func updateTheme(for sport: SplashSport) {
 
        let newColors = gradientColors(for: sport)
        let anim          = CABasicAnimation(keyPath: "colors")
        anim.fromValue    = gradientLayer.colors
        anim.toValue      = newColors
        anim.duration     = 1.6
        anim.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        anim.fillMode     = .forwards
        anim.isRemovedOnCompletion = false
        gradientLayer.colors = newColors
        gradientLayer.add(anim, forKey: "colorShift")

      
        let accentColor = sport.accentColor.cgColor
        let borderAnim  = CABasicAnimation(keyPath: "strokeColor")
        borderAnim.fromValue = cardBorderLayer.strokeColor
        borderAnim.toValue   = accentColor
        borderAnim.duration  = 1.6
        borderAnim.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        borderAnim.fillMode  = .forwards
        borderAnim.isRemovedOnCompletion = false
        cardBorderLayer.strokeColor = accentColor
        cardBorderLayer.add(borderAnim, forKey: "borderGlow")

    
        let (top, _) = sport.gradientColors
        let glowColor = top.withAlphaComponent(0.35).cgColor
        let glowAnim  = CABasicAnimation(keyPath: "colors")
        glowAnim.fromValue = glowLayer.colors
        glowAnim.toValue   = [glowColor, UIColor.clear.cgColor]
        glowAnim.duration  = 1.6
        glowAnim.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        glowAnim.fillMode  = .forwards
        glowAnim.isRemovedOnCompletion = false
        glowLayer.colors = [glowColor, UIColor.clear.cgColor]
        glowLayer.add(glowAnim, forKey: "glowShift")
 
        UIView.animate(withDuration: 0.25, animations: {
            self.cardView.transform = CGAffineTransform(scaleX: 0.97, y: 0.97)
        }, completion: { _ in
            UIView.animate(withDuration: 0.45,
                           delay: 0,
                           usingSpringWithDamping: 0.5,
                           initialSpringVelocity: 0.8,
                           options: .curveEaseOut) {
                self.cardView.transform = .identity
            }
        })
    }

    func navigateToMain() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let nextVC: UIViewController

        if UserDefaults.standard.bool(forKey: "hasSeenOnboarding") {
            let tabBar = storyboard.instantiateViewController(withIdentifier: "MainTabBarController")
            nextVC = UINavigationController(rootViewController: tabBar)
        } else {
            nextVC = storyboard.instantiateInitialViewController()!
        }

        nextVC.modalTransitionStyle   = .crossDissolve
        nextVC.modalPresentationStyle = .fullScreen

        UIView.animate(withDuration: 0.25, animations: {
            self.view.alpha = 0
        }, completion: { _ in
            self.present(nextVC, animated: false)
        })
    }
}

 
final class PulsingDotsView: UIView {
    private let dotCount = 3
    private var dots: [UIView] = []

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    private func setup() {
        for i in 0..<dotCount {
            let dot = UIView()
            dot.backgroundColor = UIColor.white.withAlphaComponent(0.55)
            dot.layer.cornerRadius = 4
            dot.translatesAutoresizingMaskIntoConstraints = false
            addSubview(dot)
            dots.append(dot)

            NSLayoutConstraint.activate([
                dot.widthAnchor.constraint(equalToConstant: 8),
                dot.heightAnchor.constraint(equalToConstant: 8),
                dot.centerYAnchor.constraint(equalTo: centerYAnchor),
                dot.leadingAnchor.constraint(equalTo: leadingAnchor, constant: CGFloat(i) * 22)
            ])

            let delay = Double(i) * 0.22
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                self.animateDot(dot)
            }
        }
    }

    private func animateDot(_ dot: UIView) {
        UIView.animate(withDuration: 0.55,
                       delay: 0,
                       options: [.repeat, .autoreverse, .curveEaseInOut]) {
            dot.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
            dot.alpha = 1
        }
    }
}
 private extension UILabel {
    func letterSpacing(_ spacing: CGFloat) {
        guard let text = text else { return }
        let attrs = NSAttributedString(string: text,
                                       attributes: [.kern: spacing])
        attributedText = attrs
    }
}
