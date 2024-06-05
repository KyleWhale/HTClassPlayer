//
//  HTClassPlayerBottomControl.swift
//  HTClassPlayer
//
//  Created by 李雪健 on 2024/6/5.
//

import Foundation

class HTClassPlayerBottomControl: UIView {
    
    var var_click: ((HTClassPlayerControlModel?) -> Void)?

    lazy var var_stackView: UIStackView = {
        let var_view = UIStackView()
        var_view.axis = .vertical
        var_view.alignment = .fill
        var_view.distribution = .fill
        return var_view
    }()
    
    var var_subviews: [UIView] = []

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
            make.top.bottom.equalToSuperview()
            make.left.right.equalToSuperview().inset(8)
        }
    }
    
    // 二维数组 用来上下排布 区分横竖屏显示逻辑
    public func ht_reloadData(_ var_datas: [[HTClassPlayerControlModel]]) {
        
        ht_removeAllSubviews()
        for var_column in var_datas {
            let var_row = UIStackView()
            var_row.axis = .horizontal
            var_row.alignment = .fill
            var_row.distribution = .fill
            var_row.spacing = 14
            var_stackView.addArrangedSubview(var_row)
            var_row.snp.remakeConstraints { make in
                make.height.equalTo(44)
            }
            for var_model in var_column {
                
                if var_model.var_type == .htEnumControlTypeProgresss {
                    let var_view = HTClassPlayerProgressView()
                    var_view.setContentHuggingPriority(.defaultLow, for: .horizontal)
                    var_view.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
                    var_row.addArrangedSubview(var_view)
                    var_subviews.append(var_view)
                } else {
                    let var_view = HTClassControlView()
                    var_view.var_click = { [weak self] var_controlModel in
                        self?.var_click?(var_controlModel)
                    }
                    var_row.addArrangedSubview(var_view)
                    if var_model.var_type == .htEnumControlTypeSpacer {
                        var_view.isUserInteractionEnabled = false
                        var_view.setContentHuggingPriority(.defaultLow, for: .horizontal)
                        var_view.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
                    } else {
                        var_view.var_model = var_model
                        if let var_image = var_model.var_image, !var_image.isEmpty {
                            var_view.snp.remakeConstraints { make in
                                make.width.equalTo(var_model.var_imageWidth)
                            }
                        }
                    }
                    var_subviews.append(var_view)
                }
            }
        }
    }
    
    func ht_containWith(_ var_type: HTEnumControlType) -> Bool {
        
        return false
    }
    
    func ht_removeAllSubviews() {
        var_subviews.removeAll()
        for var_view in var_stackView.arrangedSubviews {
            if let var_row = var_view as? UIStackView {
                for var_subview in var_row.arrangedSubviews {
                    var_row.removeArrangedSubview(var_subview)
                    var_subview.removeFromSuperview()
                }
            }
            var_stackView.removeArrangedSubview(var_view)
            var_view.removeFromSuperview()
        }
    }
}
