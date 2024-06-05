//
//  HTClassControlView.swift
//  HTClassPlayer
//
//  Created by 李雪健 on 2024/6/5.
//

import Foundation

class HTClassControlView: UIView {
    
    var var_click: ((HTClassPlayerControlModel?) -> Void)?
    
    var var_model: HTClassPlayerControlModel? {
        didSet {
            var_model?.var_updateValue = { [weak self] in
                self?.ht_update()
            }
            ht_update()
        }
    }
    
    lazy var var_titleLabel: UILabel = {
        let var_view = UILabel()
        var_view.isHidden = true
        var_view.textColor = .white
        var_view.font = .systemFont(ofSize: 14, weight: .regular)
        return var_view
    }()
    
    lazy var var_imageView: UIImageView = {
        let var_view = UIImageView()
        var_view.isHidden = true
        var_view.contentMode = .scaleAspectFit
        return var_view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        ht_setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        ht_setupViews()
    }
    
    func ht_setupViews() {
        
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
        if !var_model.var_isSelected, let var_image = var_model.var_image, !var_image.isEmpty {
            var_imageView.isHidden = false
            var_imageView.kf.setImage(with: URL(string: var_image))
        } else if var_model.var_isSelected, let var_selectImage = var_model.var_selectImage, !var_selectImage.isEmpty {
            var_imageView.isHidden = false
            var_imageView.kf.setImage(with: URL(string: var_selectImage))
        } else {
            var_imageView.isHidden = true
        }
    }
}
