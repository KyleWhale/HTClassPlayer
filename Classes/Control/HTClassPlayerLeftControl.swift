//
//  HTClassPlayerLeftControl.swift
//  HTClassPlayer
//
//  Created by 李雪健 on 2024/6/6.
//

import Foundation

public class HTClassPlayerLeftControl: UIView {
    
    public var var_click: ((HTClassPlayerControlModel?) -> Void)?

    public lazy var var_stackView: UIStackView = {
        let var_view = UIStackView()
        var_view.axis = .vertical
        var_view.alignment = .center
        var_view.distribution = .fill
        var_view.spacing = 14
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
            make.edges.equalToSuperview()
            make.width.greaterThanOrEqualTo(44)
        }
    }
    
    public func ht_reloadData(_ var_datas: [HTClassPlayerControlModel]) {
        
        ht_removeAllStackSubviews()
        for var_model in var_datas {
            let var_view = ht_subviewWith(var_model.var_type) as? HTClassControlView ?? (var_model.var_customView ?? HTClassControlView())
            var_view.var_click = { [weak self] var_controlModel in
                self?.var_click?(var_controlModel)
            }
            var_stackView.addArrangedSubview(var_view)
            if var_model.var_type == .htEnumControlTypeSpacer && var_model.var_customView == nil {
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
                } else if var_model.var_image != nil {
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
        
        if var_type == .htEnumControlTypeSpacer {
            return nil
        }
        for var_subview in var_subviews {
            if let var_view = var_subview as? HTClassControlView, var_view.var_model?.var_type == var_type {
                return var_view
            }
        }
        return nil
    }

    func ht_removeAllStackSubviews() {
        for var_view in var_stackView.arrangedSubviews {
            var_stackView.removeArrangedSubview(var_view)
            var_view.removeFromSuperview()
        }
    }
}
