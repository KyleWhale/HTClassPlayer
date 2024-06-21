//
//  HTClassControlView.swift
//  HTClassPlayer
//
//  Created by 李雪健 on 2024/6/5.
//

import Foundation

open class HTClassControlView: UIView {
    
    var var_click: ((HTClassPlayerControlModel?) -> Void)?
    
    var var_model: HTClassPlayerControlModel? {
        didSet {
            var_model?.var_updateValue = { [weak self] in
                self?.ht_update()
            }
            ht_update()
        }
    }
    // 只支持 var_model 赋值
    public lazy var var_titleLabel: UILabel = {
        let var_view = UILabel()
        var_view.isHidden = true
        var_view.textColor = .white
        var_view.font = .systemFont(ofSize: 14, weight: .regular)
        return var_view
    }()
    // 只支持 var_model 赋值
    public lazy var var_imageView: UIImageView = {
        let var_view = UIImageView()
        var_view.isHidden = true
        var_view.contentMode = .scaleAspectFit
        return var_view
    }()
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        ht_setupViews()
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        ht_setupViews()
    }
    
    open func ht_setupViews() {
        
        let var_singleTap = UITapGestureRecognizer(target: self, action: #selector(ht_singleTapAction))
        var_singleTap.numberOfTapsRequired = 1
        addGestureRecognizer(var_singleTap)

        addSubview(var_titleLabel)
        var_titleLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        addSubview(var_imageView)
        var_imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    @objc func ht_singleTapAction() {
        var_click?(var_model)
    }
    
    func ht_update() {
        guard let var_model = var_model else { return }
        if let var_title = var_model.var_title, !var_title.isEmpty {
            var_titleLabel.isHidden = false
            var_titleLabel.text = var_title
        } else {
            var_titleLabel.isHidden = true
        }
        if !var_model.var_isSelected, let var_image = var_model.var_image {
            if let var_image = var_image as? UIImage {
                var_imageView.isHidden = false
                var_imageView.image = var_image
            } else if let var_image = var_image as? String {
                var_imageView.isHidden = false
                var_imageView.kf.setImage(with: URL(string: var_image))
            } else if let var_image = var_image as? URL {
                var_imageView.isHidden = false
                var_imageView.kf.setImage(with: var_image)
            } else {
                var_imageView.isHidden = true
            }
        } else if var_model.var_isSelected, let var_selectImage = var_model.var_selectImage {
            if let var_image = var_selectImage as? UIImage {
                var_imageView.isHidden = false
                var_imageView.image = var_image
            } else if let var_image = var_selectImage as? String {
                var_imageView.isHidden = false
                var_imageView.kf.setImage(with: URL(string: var_image))
            } else if let var_image = var_selectImage as? URL {
                var_imageView.isHidden = false
                var_imageView.kf.setImage(with: var_image)
            } else {
                var_imageView.isHidden = true
            }
        } else {
            var_imageView.isHidden = true
        }
    }
    
    var var_touchAreaInsets: UIEdgeInsets = UIEdgeInsets(top: -12, left: -12, bottom: -12, right: -12) // 默认扩大区域

    open override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        let var_relativeFrame = self.bounds
        let var_hitFrame = var_relativeFrame.inset(by: var_touchAreaInsets)
        return var_hitFrame.contains(point)
    }
}
