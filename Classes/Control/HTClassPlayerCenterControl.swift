//
//  HTClassPlayerCenterControl.swift
//  HTClassPlayer
//
//  Created by 李雪健 on 2024/6/5.
//

import Foundation

public class HTClassPlayerCenterControl: UIView {
    
    var var_click: ((HTClassPlayerControlModel?) -> Void)?

    lazy var var_stackView: UIStackView = {
        let var_view = UIStackView()
        var_view.axis = .horizontal
        var_view.alignment = .center
        var_view.distribution = .fill
        var_view.spacing = 70
        return var_view
    }()
    
    public var var_subviews: [UIView] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        ht_setupViews()
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        ht_setupViews()
    }
    
    func ht_setupViews() {

        addSubview(var_stackView)
        var_stackView.snp.makeConstraints { (make) in
            make.height.greaterThanOrEqualTo(44)
            make.edges.equalToSuperview()
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
                if let var_image = var_model.var_image, !var_image.isEmpty {
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
