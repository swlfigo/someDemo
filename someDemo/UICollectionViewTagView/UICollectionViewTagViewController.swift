//
//  UICollectionViewTagViewController.swift
//  someDemo
//
//  Created by sylar on 2025/7/2.
//

import Foundation
import UIKit


// Tag类型枚举
fileprivate enum TagType {
    case text(NSAttributedString)
    case textWithEmoji(NSAttributedString, String)
    case imageWithText(UIImage, NSAttributedString)
}

// Tag数据模型
fileprivate struct TagItem {
    let type: TagType
}

// TagCell自定义cell
fileprivate class TagCell: UICollectionViewCell {
    static let reuseIdentifier = "TagCell"
    let label = UILabel()
    let imageView = UIImageView()
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(label)
        contentView.addSubview(imageView)
        label.numberOfLines = 1
        label.textAlignment = .center
        imageView.contentMode = .scaleAspectFit
        imageView.isHidden = true
        label.isHidden = true
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        // 只显示图片+文字时，图片和label左右排列
        if !imageView.isHidden && !label.isHidden {
            let imageW: CGFloat = 20
            imageView.frame = CGRect(x: 5, y: (contentView.bounds.height-imageW)/2, width: imageW, height: imageW)
            label.frame = CGRect(x: imageView.frame.maxX+4, y: 0, width: contentView.bounds.width-imageView.frame.maxX-9, height: contentView.bounds.height)
        } else {
            label.frame = contentView.bounds
            imageView.frame = contentView.bounds
        }
    }
    func configure(with item: TagItem) {
        switch item.type {
        case .text(let attrText):
            label.attributedText = attrText
            label.isHidden = false
            imageView.isHidden = true
        case .textWithEmoji(let attrText, let emoji):
            let mutable = NSMutableAttributedString(attributedString: attrText)
            mutable.append(NSAttributedString(string: " " + emoji))
            label.attributedText = mutable
            label.isHidden = false
            imageView.isHidden = true
        case .imageWithText(let img, let attrText):
            imageView.image = img
            label.attributedText = attrText
            imageView.isHidden = false
            label.isHidden = false
        }
    }
}



class UICollectionViewTagViewController: SomeDemoBaseViewController , UICollectionViewDataSource, UICollectionViewDelegate, TagFlowLayoutDelegate  {
    var collectionView: UICollectionView!
    fileprivate var tags: [TagItem] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        // 测试数据
        tags = [
            TagItem(type: .text(NSAttributedString(string: "纯文字", attributes: [.foregroundColor: UIColor.systemBlue, .font: UIFont.boldSystemFont(ofSize: 15)]))),
            TagItem(type: .textWithEmoji(NSAttributedString(string: "带emoji", attributes: [.foregroundColor: UIColor.systemRed, .font: UIFont.systemFont(ofSize: 15)]), "🔥")),
            TagItem(type: .imageWithText(UIImage(systemName: "star.fill")!, NSAttributedString(string: "收藏", attributes: [.foregroundColor: UIColor.systemYellow, .font: UIFont.systemFont(ofSize: 15)]))),
            TagItem(type: .text(NSAttributedString(string: "TagView演示", attributes: [.foregroundColor: UIColor.systemGreen, .font: UIFont.systemFont(ofSize: 15)]))),
            TagItem(type: .textWithEmoji(NSAttributedString(string: "SwiftUI", attributes: [.foregroundColor: UIColor.systemPurple, .font: UIFont.systemFont(ofSize: 15)]), "🚀")),
            TagItem(type: .imageWithText(UIImage(systemName: "heart.fill")!, NSAttributedString(string: "喜欢", attributes: [.foregroundColor: UIColor.systemPink, .font: UIFont.systemFont(ofSize: 15)])))
        ]
        // 布局
        let layout = TagFlowLayout()
        layout.delegate = self
        layout.headerReferenceSize = CGSize(width: view.bounds.width, height: 40)
        layout.footerReferenceSize = CGSize(width: view.bounds.width, height: 40)
        // collectionView
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .white
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(TagCell.self, forCellWithReuseIdentifier: TagCell.reuseIdentifier)
        collectionView.register(HeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "HeaderView")
        collectionView.register(FooterView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "FooterView")
        view.addSubview(collectionView)
    }
    // MARK: - DataSource
    func numberOfSections(in collectionView: UICollectionView) -> Int { 1 }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int { tags.count }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TagCell.reuseIdentifier, for: indexPath) as! TagCell
        cell.configure(with: tags[indexPath.item])
        cell.contentView.backgroundColor = UIColor.systemGray6
        cell.contentView.layer.cornerRadius = 14
        cell.contentView.layer.masksToBounds = true
        return cell
    }
    // MARK: - Header/Footer
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "HeaderView", for: indexPath) as! HeaderView
            header.label.text = "Header 示例"
            return header
        } else {
            let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "FooterView", for: indexPath) as! FooterView
            footer.label.text = "Footer 示例"
            return footer
        }
    }
    // MARK: - TagFlowLayoutDelegate
    fileprivate func collectionView(_ collectionView: UICollectionView, layout: TagFlowLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let item = tags[indexPath.item]
        switch item.type {
        case .text(let attrText):
            let size = attrText.boundingRect(with: CGSize(width: 200, height: 32), options: .usesLineFragmentOrigin, context: nil).size
            return CGSize(width: size.width+24, height: 32)
        case .textWithEmoji(let attrText, let emoji):
            let mutable = NSMutableAttributedString(attributedString: attrText)
            mutable.append(NSAttributedString(string: " " + emoji))
            let size = mutable.boundingRect(with: CGSize(width: 200, height: 32), options: .usesLineFragmentOrigin, context: nil).size
            return CGSize(width: size.width+24, height: 32)
        case .imageWithText(_, let attrText):
            let size = attrText.boundingRect(with: CGSize(width: 200, height: 32), options: .usesLineFragmentOrigin, context: nil).size
            return CGSize(width: size.width+44, height: 32)
        }
    }
}

// Header/Footer View
private class HeaderView: UICollectionReusableView {
    let label = UILabel()
    override init(frame: CGRect) {
        super.init(frame: frame)
        label.frame = bounds
        label.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 18)
        addSubview(label)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}

private class FooterView: UICollectionReusableView {
    let label = UILabel()
    override init(frame: CGRect) {
        super.init(frame: frame)
        label.frame = bounds
        label.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 16)
        addSubview(label)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}

// 自动换行的TagFlowLayout
private class TagFlowLayout: UICollectionViewFlowLayout {
    let itemSpacing: CGFloat = 8
    let lineSpacing: CGFloat = 8
    let sectionInsetCustom = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
    private var layoutAttributes: [UICollectionViewLayoutAttributes] = []
    private var contentHeight: CGFloat = 0

    weak var delegate: TagFlowLayoutDelegate?
    override func prepare() {
        super.prepare()
        guard let collectionView = collectionView else { return }
        layoutAttributes.removeAll()
        contentHeight = 0
        let sectionCount = collectionView.numberOfSections
        var yOffset: CGFloat = 0
        for section in 0..<sectionCount {
            // header
            let headerSize = headerReferenceSize
            if headerSize.height > 0 {
                let headerAttr = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, with: IndexPath(item: 0, section: section))
                headerAttr.frame = CGRect(x: 0, y: yOffset, width: collectionView.bounds.width, height: headerSize.height)
                layoutAttributes.append(headerAttr)
                yOffset += headerSize.height
            }
            yOffset += sectionInsetCustom.top
            var xOffset: CGFloat = sectionInsetCustom.left
            let itemCount = collectionView.numberOfItems(inSection: section)
            var maxLineHeight: CGFloat = 0
            for item in 0..<itemCount {
                let indexPath = IndexPath(item: item, section: section)
                let itemSize = delegate?.collectionView(collectionView, layout: self, sizeForItemAt: indexPath) ?? CGSize(width: 60, height: 32)
                if xOffset + itemSize.width + sectionInsetCustom.right > collectionView.bounds.width {
                    xOffset = sectionInsetCustom.left
                    yOffset += maxLineHeight + lineSpacing
                    maxLineHeight = 0
                }
                let attr = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                attr.frame = CGRect(x: xOffset, y: yOffset, width: itemSize.width, height: itemSize.height)
                layoutAttributes.append(attr)
                xOffset += itemSize.width + itemSpacing
                maxLineHeight = max(maxLineHeight, itemSize.height)
            }
            yOffset += maxLineHeight + sectionInsetCustom.bottom
            // footer
            let footerSize = footerReferenceSize
            if footerSize.height > 0 {
                let footerAttr = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, with: IndexPath(item: 0, section: section))
                footerAttr.frame = CGRect(x: 0, y: yOffset, width: collectionView.bounds.width, height: footerSize.height)
                layoutAttributes.append(footerAttr)
                yOffset += footerSize.height
            }
        }
        contentHeight = yOffset
    }

    override var collectionViewContentSize: CGSize {
        return CGSize(width: collectionView?.bounds.width ?? 0, height: contentHeight)
    }

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return layoutAttributes.filter { $0.frame.intersects(rect) }
    }

    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return layoutAttributes.first { $0.indexPath == indexPath && $0.representedElementCategory == .cell }
    }

    override func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return layoutAttributes.first { $0.indexPath == indexPath && $0.representedElementKind == elementKind }
    }
}

fileprivate protocol TagFlowLayoutDelegate: AnyObject {
    func collectionView(_ collectionView: UICollectionView, layout: TagFlowLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
}
