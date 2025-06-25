//
//  UITableViewDiffableDataSourceExpandCell.swift
//  someDemo
//
//  Created by sylar on 2025/6/25.
//

import Foundation
import UIKit

enum UITableViewDiffableDataSourceDemoCellItem: Hashable {
    case normal(MyModel)
    case expand(UITableViewDiffableDataSourceTextItem)
}

struct MyModel: Hashable {
    var title: String
    let id: UUID = UUID()
}

struct UITableViewDiffableDataSourceTextItem: Hashable {

    let id = UUID()
    let text: String
    var isExpanded: Bool

}

// MARK: - Cell Delegate Protocol
protocol UITableViewDiffableDataSourceExpandCellDelegate: AnyObject {
    func didTapExpand(_ cell: UITableViewDiffableDataSourceExpandCell)
}

class UITableViewDiffableDataSourceExpandCell: UITableViewCell {
    weak var delegate: UITableViewDiffableDataSourceExpandCellDelegate?

    // UILabel支持多行且允许富文本
    private let contentLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 3  // 默认显示3行
        label.lineBreakMode = .byTruncatingTail
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    // 透明按钮覆盖label末尾“展开”文字以实现点击事件，也可以用手势，这里用按钮方便
    private let expandButton = UIButton(type: .system)

    // 存储完整文字
    private var fullText: String = ""

    // 展开时是否是展开状态
    private var expanded: Bool = false

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        contentView.addSubview(contentLabel)
        contentView.addSubview(expandButton)
        contentLabel.leadingAnchor.constraint(
            equalTo: contentView.leadingAnchor,
            constant: 15
        ).isActive = true
        contentLabel.trailingAnchor.constraint(
            equalTo: contentView.trailingAnchor,
            constant: -15
        ).isActive = true
        contentLabel.topAnchor.constraint(
            equalTo: contentView.topAnchor,
            constant: 10
        ).isActive = true
        contentLabel.bottomAnchor.constraint(
            equalTo: expandButton.topAnchor,
            constant: -8
        ).isActive = true

        // 配置按钮
        expandButton.setTitle("展开", for: .normal)
        expandButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        expandButton.addTarget(
            self,
            action: #selector(expandTapped),
            for: .touchUpInside
        )
        expandButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            expandButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            expandButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            expandButton.heightAnchor.constraint(equalToConstant: 20),
            expandButton.widthAnchor.constraint(equalToConstant: 50)
        ])
        // 先隐藏按钮，后续需要显示才布局
        expandButton.isHidden = true
    }

    @objc private func expandTapped() {
        delegate?.didTapExpand(self)
    }

    // 设置内容与展开状态
    func configure(
        with item: UITableViewDiffableDataSourceTextItem
    ) {
        self.fullText = item.text
        self.expanded = item.isExpanded

        if expanded {
            // 展开状态，完整显示全部文本
            contentLabel.numberOfLines = 0
            // 内容加个“收起”按钮文本
            let attributedString = NSMutableAttributedString(
                string: fullText + " 收起"
            )
            attributedString.addAttribute(
                .foregroundColor,
                value: UIColor.systemBlue,
                range: NSRange(location: fullText.count + 1, length: 2)
            )
            contentLabel.attributedText = attributedString

            // 展开按钮隐藏，因为“收起”显示在label内，监听点击 label 即可（这里简化用按钮）
            expandButton.isHidden = false
            expandButton.setTitle("收起", for: .normal)

        } else {
            // 收起状态
            contentLabel.numberOfLines = 3

            // 构造3行带展开的显示 — 这里粗略处理，实际复杂需要更精准截断
            // 先显示全文本，若超3行则显示截断文本 + 展开字样
            // 要实现尾部“...展开”，常用方法是利用富文本加附件或手动截断。这里做简单方式：

            // 先给contentLabel设置原始文本，numberOfLines=3，lineBreakMode=.byTruncatingTail即可自动添加省略号
            // 然后显示 expandButton 来触发展开

            contentLabel.text = fullText
            expandButton.isHidden = false
            expandButton.setTitle("展开", for: .normal)
        }
    }
}
