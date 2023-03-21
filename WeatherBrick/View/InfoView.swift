//
//  InfoView.swift
//  WeatherBrick
//
//  Created by Olya Sabadina on 2023-03-13.
//

import UIKit

class InfoView: UIView {

    private var shadowLayer: CAShapeLayer!
    private var cornerRadius: CGFloat = 25.0
    private var fillColor: UIColor = .blue
    
    let color = #colorLiteral(red: 0.5763047668, green: 0.2355876396, blue: 0.05401653666, alpha: 1)
    let imageView = UIImageView()
    let containerView = UIView()
    let closeButton = UIButton()
    
    let infoLabel: UILabel = {
       let label = UILabel()
        label.font = .systemFont(ofSize: 24)
        label.text = "INFO"
        label.textAlignment = .center
        return label
    }()
    
    let textInfoLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18)
        label.text = """
            Brick is wet - raining
            
            Brick is dry - sunny
            
            Brick is hard to see - fog
            
            Brick with cracks - very hot
            
            Brick with snow - snow
            
            Brick is swinging - windy
            
            Brick is gone - No Internet
            """
        label.numberOfLines = 0
        label.sizeToFit()
        return label
    }()
    
    lazy var stack: UIStackView = {
       let stack = UIStackView(arrangedSubviews: [infoLabel,textInfoLabel])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 25
        return stack
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = .white
        self.frame = UIScreen.main.bounds
        setupView()
        setupButton()
    }
    
    func setupView(){
        addSubview(imageView)
        imageView.image = UIImage(named: "image_background")
        imageView.frame = self.frame
        
        addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(stack)
        containerView.backgroundColor = .systemOrange
        containerView.addShadow(cornerRadius: 25 ,offset: CGSize(width: 5, height: 2), color: color, radius: 1, opacity: 1)
    }
    
    func setupButton(){
        containerView.addSubview(closeButton)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        closeButton.setTitle("Hide", for: .normal)
        closeButton.setTitleColor(.black, for: .normal)
        closeButton.layer.cornerRadius = 20
        closeButton.layer.borderWidth = 2
        closeButton.layer.borderColor = UIColor.black.cgColor
        closeButton.addTarget(self, action: #selector(closeWindow), for: .touchUpInside)
    }
    
    @objc func closeWindow(){
        self.removeFromSuperview()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(Coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        NSLayoutConstraint.activate([
            
            containerView.centerYAnchor.constraint(equalTo: centerYAnchor),
            containerView.centerXAnchor.constraint(equalTo: centerXAnchor),
            containerView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.78),
            containerView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.7),
          
            closeButton.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            closeButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -20),
            closeButton.widthAnchor.constraint(equalToConstant: 150),
            closeButton.heightAnchor.constraint(equalToConstant: 40),
            
            stack.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            stack.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 10),
            stack.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20)
        ])
    }
}

extension UIView {
   
    func addShadow(cornerRadius: CGFloat, offset: CGSize, color: UIColor, radius: CGFloat, opacity: Float) {
        layer.cornerRadius = cornerRadius
        layer.shadowColor = color.cgColor
        layer.shadowOffset = offset
        layer.shadowOpacity = opacity
        layer.shadowRadius = radius
        layer.masksToBounds = false
    }
    
    func setShadowWithCornerRadius(cornerRadius: CGFloat, shadowColor: UIColor, shadowOffset: CGSize, shadoeOpacity: Float = 1, shadowRadius: CGFloat = 15){
        layer.cornerRadius = cornerRadius
        layer.shadowColor = shadowColor.cgColor
        layer.shadowOffset = shadowOffset
        layer.shadowOpacity = shadoeOpacity
        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius).cgPath
        layer.shadowRadius = shadowRadius
    }

}
