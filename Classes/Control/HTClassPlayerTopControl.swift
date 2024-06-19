//
//  HTClassPlayerTopControl.swift
//  HTClassPlayer
//
//  Created by 李雪健 on 2024/6/5.
//

import Foundation

public class HTClassPlayerTopControl: UIView {
    
    public let var_gradientLayer = CAGradientLayer()

    var var_click: ((HTClassPlayerControlModel?) -> Void)?

    lazy var var_stackView: UIStackView = {
        let var_view = UIStackView()
        var_view.axis = .horizontal
        var_view.alignment = .center
        var_view.distribution = .fill
        var_view.spacing = 14
        return var_view
    }()
    
    public var var_subviews: [UIView] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        ht_setupViews()
        ht_setupGradientLayer()
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        ht_setupViews()
        ht_setupGradientLayer()
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        var_gradientLayer.frame = bounds
        
        if UIScreen.main.bounds.size.width > UIScreen.main.bounds.size.height {
            var_stackView.snp.remakeConstraints { (make) in
                make.top.equalTo(10)
                make.bottom.equalToSuperview()
                make.height.greaterThanOrEqualTo(44)
                make.left.right.equalToSuperview().inset(18)
            }
        } else {
            var_stackView.snp.remakeConstraints { (make) in
                make.top.bottom.equalToSuperview()
                make.height.greaterThanOrEqualTo(44)
                make.left.right.equalToSuperview().inset(8)
            }
        }
    }
    
    // 添加渐变色
    func ht_setupGradientLayer() {
        
        var_gradientLayer.colors = [UIColor.black.withAlphaComponent(0.8).cgColor, UIColor.clear.cgColor]
        var_gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
        var_gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
        layer.insertSublayer(var_gradientLayer, at: 0)
    }
    
    func ht_setupViews() {

        addSubview(var_stackView)
        var_stackView.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.height.greaterThanOrEqualTo(44)
            make.left.right.equalToSuperview().inset(8)
        }
    }
    
    public func ht_reloadData(_ var_datas: [HTClassPlayerControlModel]) {
        
        ht_removeAllSubviews()
        for var_model in var_datas {
            let var_view = ht_subviewWith(var_model.var_type) as? HTClassControlView ?? (var_model.var_customView ?? HTClassControlView())
            var_view.var_click = { [weak self] var_controlModel in
                self?.var_click?(var_controlModel)
            }
            var_stackView.addArrangedSubview(var_view)
            if var_model.var_type == .htEnumControlTypeSpacer || var_model.var_type == .htEnumControlTypeProgresss {
                var_view.isUserInteractionEnabled = false
                var_view.setContentHuggingPriority(.defaultLow, for: .horizontal)
                var_view.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
                var_view.snp.remakeConstraints { make in
                    make.size.greaterThanOrEqualTo(var_model.var_size)
                }
            } else {
                var_view.var_model = var_model
                if var_model.var_customView != nil {
                    var_view.snp.remakeConstraints { make in
                        make.size.equalTo(var_model.var_size)
                    }
                } else if let var_image = var_model.var_image, !var_image.isEmpty {
                    var_view.snp.remakeConstraints { make in
                        make.size.equalTo(var_model.var_size)
                    }
                }
            }
            if !var_subviews.contains(var_view) {
                var_subviews.append(var_view)
            }
        }
    }

    func ht_subviewWith(_ var_type: HTEnumControlType) -> UIView? {
        
        for var_subview in var_subviews {
            if var_type == .htEnumControlTypeProgresss, var_subview is HTClassPlayerProgressView {
                return var_subview
            }
            if let var_view = var_subview as? HTClassControlView, var_view.var_model?.var_type == var_type {
                return var_view
            }
        }
        return nil
    }

    func ht_removeAllSubviews() {
        for var_view in var_stackView.arrangedSubviews {
            var_stackView.removeArrangedSubview(var_view)
            var_view.removeFromSuperview()
        }
    }
}
