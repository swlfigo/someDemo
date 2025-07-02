//
//  UICollectionviewAutoLayoutViewController.swift
//  someDemo
//
//  Created by sylar on 2025/7/2.
//

import Foundation
import UIKit

private enum CellType {
    case text(String)
    case constText(String)
    case imageWithText(UIImage, String)
}

private struct Item {
    let type: CellType
}

class UICollectionviewAutoLayoutViewController: SomeDemoBaseViewController {
    private var items: [Item] = []
    private var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupData()
        setupCollectionView()
    }
    
    private func setupData() {
        // 构造多种类型和高度的cell数据
        items = [
            Item(type: .text("短文本")),
            Item(type: .constText("定高150Cell")),
            Item(type: .text("这是一个很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长的文本，用于测试AutoLayout下的高度自适应。再加一段：Swift UICollectionView 自动布局，label自动换行，cell高度自适应，效果如UITableView。再加一段：如果你看到这段文字说明label已经自动换行并且cell高度自适应了。")),
            Item(type: .imageWithText(UIImage(systemName: "star")!, "Image With Text")),
            Item(type: .imageWithText(UIImage(systemName: "person.circle")!, "Image With Text")),
            Item(type: .imageWithText(UIImage(systemName: "flame")!, "图文混排cell，短文本")),
            Item(type: .imageWithText(UIImage(systemName: "bolt")!, "图文混排cell，长文本，测试自动换行和高度自适应。这里有一段很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长的文本。再加一段：Swift UICollectionView 自动布局，label自动换行，cell高度自适应，效果如UITableView。")),
        ]
    }
    
    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        //需要设置为AutomaticSize
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
//        layout.itemSize = CGSizeMake(view.frame.size.width, 100)
        layout.minimumLineSpacing = 20
        layout.sectionInset = UIEdgeInsets(top: 20, left: 16, bottom: 20, right: 16)
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .systemGroupedBackground
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(TextCell.self, forCellWithReuseIdentifier: "TextCell")
        collectionView.register(ImageCell.self, forCellWithReuseIdentifier: "ImageCell")
        collectionView.register(ConstantHeightTextCell.self, forCellWithReuseIdentifier: "ConstantHeightCell")
        view.addSubview(collectionView)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.frame
    }
    
}




extension UICollectionviewAutoLayoutViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = items[indexPath.item]
        switch item.type {
        case .text(let t):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TextCell", for: indexPath) as! TextCell
            cell.label.text = t
            return cell
        case .imageWithText(let i, let t):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as! ImageCell
            cell.imageView.image = i
            cell.label.text = t
            return cell
        case .constText(let t):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ConstantHeightCell", for: indexPath) as! ConstantHeightTextCell
            cell.label.text = t
            return cell
        }
    }
}

private class ConstantHeightTextCell : UICollectionViewCell {
    let label = UILabel()
    private lazy var containerView = UIView()
    private var widthConstraint: NSLayoutConstraint?
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.green.cgColor
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 16)
        label.backgroundColor = UIColor(white: 0.95, alpha: 1.0) // 浅灰色背景
        contentView.addSubview(label)
        label.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().offset(12)
            make.trailing.equalToSuperview().offset(-12)
        }
        widthConstraint = contentView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.size.width)
        widthConstraint?.isActive = false
    }
    
    
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        if let collectionView = self.superview as? UICollectionView {
            let sectionInset = (collectionView.collectionViewLayout as? UICollectionViewFlowLayout)?.sectionInset ?? .zero
            let width = collectionView.bounds.width - sectionInset.left - sectionInset.right
            widthConstraint?.constant = width
            widthConstraint?.isActive = true
            
            //写死高度
            var cellFrame = layoutAttributes.frame
            cellFrame.size.height = 150
            layoutAttributes.frame = cellFrame
        }
        return super.preferredLayoutAttributesFitting(layoutAttributes)
    }
}


private class TextCell: UICollectionViewCell {
    let label = UILabel()
    private lazy var containerView = UIView()
    private var widthConstraint: NSLayoutConstraint?
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.orange.cgColor
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 16)
        label.backgroundColor = UIColor(white: 0.95, alpha: 1.0) // 浅灰色背景
        contentView.addSubview(label)
        label.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().offset(12)
            make.trailing.equalToSuperview().offset(-12)
            make.bottom.equalToSuperview().offset(-20).priority(.high)
        }
        widthConstraint = contentView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.size.width)
        widthConstraint?.isActive = false
    }
    
    
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        if let collectionView = self.superview as? UICollectionView {
            let sectionInset = (collectionView.collectionViewLayout as? UICollectionViewFlowLayout)?.sectionInset ?? .zero
            let width = collectionView.bounds.width - sectionInset.left - sectionInset.right
            widthConstraint?.constant = width
            widthConstraint?.isActive = true
        }
        return super.preferredLayoutAttributesFitting(layoutAttributes)
    }
}

private class ImageCell: UICollectionViewCell {
    let imageView = UIImageView()
    let label = UILabel()
    private var widthConstraint: NSLayoutConstraint?
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.red.cgColor
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .systemRed
        contentView.addSubview(imageView)
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 15)
        contentView.addSubview(label)
        imageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.centerX.equalToSuperview()
        }
        label.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(12)
            make.leading.equalToSuperview().offset(12)
            make.trailing.equalToSuperview().offset(-12)
            make.bottom.equalToSuperview().offset(-20).priority(.high)
        }
        //先设置为大于上面约束-12 12 的宽度
        widthConstraint = contentView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.size.width)
        widthConstraint?.isActive = false
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        if let collectionView = self.superview as? UICollectionView {
            let sectionInset = (collectionView.collectionViewLayout as? UICollectionViewFlowLayout)?.sectionInset ?? .zero
            let width = collectionView.bounds.width - sectionInset.left - sectionInset.right
            widthConstraint?.constant = width
            widthConstraint?.isActive = true
        }
        return super.preferredLayoutAttributesFitting(layoutAttributes)
    }
}
