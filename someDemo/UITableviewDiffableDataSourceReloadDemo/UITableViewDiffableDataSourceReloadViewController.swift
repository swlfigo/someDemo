//
//  UITableViewDiffableDataSourceReloadViewController.swift
//  someDemo
//
//  Created by sylar on 2025/8/3.
//

import Foundation
import UIKit
// 数据模型
fileprivate class Item: Hashable {
    let id = UUID()
    let name: String
    var isSelected: Bool
    
    init(name: String, isSelected: Bool = false) {
        self.name = name
        self.isSelected = isSelected
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: Item, rhs: Item) -> Bool {
        return lhs.id == rhs.id
    }
}

// Cell 类
fileprivate class ItemTableViewCell: UITableViewCell {
    static let identifier = "ItemCell"
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    private let markView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.borderWidth = 2
        view.layer.borderColor = UIColor.systemBlue.cgColor
        view.layer.cornerRadius = 12
        return view
    }()
    
    private let checkmarkImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = UIColor.systemBlue
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.addSubview(markView)
        markView.addSubview(checkmarkImageView)
        contentView.addSubview(nameLabel)
        
        NSLayoutConstraint.activate([
            markView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            markView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            markView.widthAnchor.constraint(equalToConstant: 24),
            markView.heightAnchor.constraint(equalToConstant: 24),
            
            checkmarkImageView.centerXAnchor.constraint(equalTo: markView.centerXAnchor),
            checkmarkImageView.centerYAnchor.constraint(equalTo: markView.centerYAnchor),
            checkmarkImageView.widthAnchor.constraint(equalToConstant: 16),
            checkmarkImageView.heightAnchor.constraint(equalToConstant: 16),
            
            nameLabel.leadingAnchor.constraint(equalTo: markView.trailingAnchor, constant: 12),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            nameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    func configure(with item: Item) {
        nameLabel.text = item.name
        updateMarkView(isSelected: item.isSelected)
    }
    
    private func updateMarkView(isSelected: Bool) {
        if isSelected {
            markView.backgroundColor = UIColor.systemBlue
            checkmarkImageView.image = UIImage(systemName: "checkmark")
            checkmarkImageView.isHidden = false
        } else {
            markView.backgroundColor = UIColor.clear
            checkmarkImageView.isHidden = true
        }
    }
}

class UITableViewDiffableDataSourceReloadViewController : SomeDemoBaseViewController {
    private var tableView: UITableView!
    private var dataSource: UITableViewDiffableDataSource<Int, Item>!
    private var items: [Item] = []
    private var selectAllButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        setupData()
        setupSelectAllButton()
        setupTableView()
        setupDataSource()
        applySnapshot()
        updateSelectAllButtonTitle()
    }
    
    private func setupData() {
        items = [
            Item(name: "苹果"),
            Item(name: "香蕉"),
            Item(name: "橙子"),
            Item(name: "葡萄"),
            Item(name: "草莓")
        ]
    }
    
    private func setupSelectAllButton() {
        selectAllButton = UIButton(type: .system)
        selectAllButton.translatesAutoresizingMaskIntoConstraints = false
        selectAllButton.setTitle("全选", for: .normal)
        selectAllButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        selectAllButton.setTitleColor(.systemBlue, for: .normal)
        selectAllButton.backgroundColor = UIColor.systemGray6
        selectAllButton.layer.cornerRadius = 8
        selectAllButton.addTarget(self, action: #selector(selectAllButtonTapped), for: .touchUpInside)
        
        view.addSubview(selectAllButton)
        
        NSLayoutConstraint.activate([
            selectAllButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            selectAllButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            selectAllButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            selectAllButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    private func setupTableView() {
        tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(ItemTableViewCell.self, forCellReuseIdentifier: ItemTableViewCell.identifier)
        tableView.delegate = self
        tableView.rowHeight = 60
        
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: selectAllButton.bottomAnchor, constant: 16),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupDataSource() {
        dataSource = UITableViewDiffableDataSource<Int, Item>(tableView: tableView) { tableView, indexPath, item in
            let cell = tableView.dequeueReusableCell(withIdentifier: ItemTableViewCell.identifier, for: indexPath) as! ItemTableViewCell
            cell.configure(with: item)
            return cell
        }
    }
    
    private func applySnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Int, Item>()
        snapshot.appendSections([0])
        snapshot.appendItems(items, toSection: 0)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    private func updateItem(at indexPath: IndexPath) {
        // 更新数据模型
        items[indexPath.row].isSelected.toggle()
        
        // 使用 DiffableDataSource 的正确方式更新数据
        var snapshot = dataSource.snapshot()
        snapshot.reloadItems([items[indexPath.row]])
        dataSource.apply(snapshot, animatingDifferences: true)
        
        // 更新按钮标题
        updateSelectAllButtonTitle()
    }
    
    @objc private func selectAllButtonTapped() {
        let allSelected = items.allSatisfy { $0.isSelected }
        
        // 如果全部选中，则取消全选；否则全选
        let newSelectionState = !allSelected
        
        // 更新所有项目的选中状态
        for item in items {
            item.isSelected = newSelectionState
        }
        
        // 使用 reloadItems 来确保 UI 正确更新
        var snapshot = dataSource.snapshot()
        snapshot.reloadItems(items)
        dataSource.apply(snapshot, animatingDifferences: true)
        
        // 更新按钮标题
        updateSelectAllButtonTitle()
    }
    
    private func updateSelectAllButtonTitle() {
        let allSelected = items.allSatisfy { $0.isSelected }
        let title = allSelected ? "取消全选" : "全选"
        selectAllButton.setTitle(title, for: .normal)
    }
}

// MARK: - UITableViewDelegate
extension UITableViewDiffableDataSourceReloadViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        updateItem(at: indexPath)
    }
}
