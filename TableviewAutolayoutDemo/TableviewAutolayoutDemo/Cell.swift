//
//  Style1Cell.swift
//  TableviewAutolayoutDemo
//
//  Created by sylar on 2025/5/31.
//

import Foundation
import UIKit
import YYText

let gap : CGFloat = 20


class Style1Wrapper {
    var isExpand : Bool
    var attributeStr : NSAttributedString
    
    init(isExpand: Bool = false, attributeStr: NSAttributedString) {
        self.isExpand = isExpand
        self.attributeStr = attributeStr
    }
}

class Style1Cell : UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super .init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var contentLabel : YYLabel = .init()
    
    var wrapperModel : Style1Wrapper? {
        didSet {
            guard let wrapperModel = wrapperModel else {return}
            
            
            contentLabel.attributedText = wrapperModel.attributeStr
            
            /*
             Calculate
             */
            let container = YYTextContainer(size: CGSizeMake(UIScreen.main.bounds.size.width - gap * 2, .infinity))
            container.maximumNumberOfRows = 0
            let layout = YYTextLayout(container: container, text: wrapperModel.attributeStr)
            if let layout = layout {
                print("YYLabel Attribute Height:\(layout.textBoundingRect.height)")
            }
        }
    }
    
    private func setupUI(){
        contentView.addSubview(contentLabel)
        contentLabel.numberOfLines = 0
        

        contentLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(gap)
            make.trailing.equalToSuperview().offset(-gap)
            make.top.equalToSuperview().offset(100)
            make.bottom.equalToSuperview().offset(-10).priority(.high)
        }

        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentLabel.preferredMaxLayoutWidth = CGRectGetWidth(contentView.frame) - gap * 2
    }
}

class Style2Wrapper {
    
}

class Style2Cell : UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super .init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var contentLabel : UILabel = .init()
    
    private func setupUI(){
        contentView.addSubview(contentLabel)
        
        let attText = NSMutableAttributedString.init(string: "This is Short Text Cell Style")
        let paragraph = NSMutableParagraphStyle()
        paragraph.lineSpacing = 2
        attText.addAttributes([
            .foregroundColor:UIColor.black,
            .font:UIFont.systemFont(ofSize: 14),
            .paragraphStyle:paragraph
        ], range: NSRange(location: 0, length: attText.length))
        
        contentLabel.attributedText = NSAttributedString(attributedString: attText)
        contentLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(gap)
            make.trailing.equalToSuperview().offset(-gap)
            make.top.equalToSuperview().offset(10)
            make.bottom.equalToSuperview().offset(-15).priority(.high)
        }
    }
    
}
