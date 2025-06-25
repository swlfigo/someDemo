//
//  UITableViewDiffableDataSourceDemoViewController.swift
//  someDemo
//
//  Created by sylar on 2025/6/25.
//

import Foundation
import UIKit

private enum Section: CaseIterable {
    case main
}

class UITableViewDiffableDataSourceDemoViewController:
    SomeDemoBaseViewController
{
    private var tbView: UITableView = .init(frame: .zero, style: .plain)
    private var dataSource:
        UITableViewDiffableDataSource<
            Section, UITableViewDiffableDataSourceDemoCellItem
        >!

    var mainModels: [UITableViewDiffableDataSourceDemoCellItem] = [
        .normal(MyModel(title: "Item1")),
        .normal(MyModel(title: "Item2")),
        .normal(MyModel(title: "Item3")),
        .expand(
            UITableViewDiffableDataSourceTextItem.init(
                text: loremText,
                isExpanded: false
            )
        ),
        .expand(
            UITableViewDiffableDataSourceTextItem.init(
                text: loremText,
                isExpanded: false
            )
        ),
        .expand(
            UITableViewDiffableDataSourceTextItem.init(
                text: loremText,
                isExpanded: false
            )
        ),
        .expand(
            UITableViewDiffableDataSourceTextItem.init(
                text: loremText,
                isExpanded: false
            )
        ),
        .expand(
            UITableViewDiffableDataSourceTextItem.init(
                text: loremText,
                isExpanded: false
            )
        ),
    ]
    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(tbView)
        tbView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        tbView.register(
            UITableViewCell.self,
            forCellReuseIdentifier: "\(UITableViewCell.self)"
        )
        tbView.register(
            UITableViewDiffableDataSourceExpandCell.self,
            forCellReuseIdentifier:
                "\(UITableViewDiffableDataSourceExpandCell.self)"
        )
        dataSource = UITableViewDiffableDataSource<
            Section, UITableViewDiffableDataSourceDemoCellItem
        >(
            tableView: tbView,
            cellProvider: { tableView, indexPath, model in

                switch model {
                case .normal(let normalModel):
                    let cell = tableView.dequeueReusableCell(
                        withIdentifier: "\(UITableViewCell.self)"
                    )!
                    cell.textLabel?.text = normalModel.title
                    cell.textLabel?.textColor = .black
                    return cell
                case .expand(let expandModel):
                    let cell =
                        tableView.dequeueReusableCell(
                            withIdentifier:
                                "\(UITableViewDiffableDataSourceExpandCell.self)"
                        ) as! UITableViewDiffableDataSourceExpandCell
                    cell.configure(with: expandModel)
                    cell.delegate = self
                    return cell
                default:
                    break
                }

                let cell = tableView.dequeueReusableCell(
                    withIdentifier: "\(UITableViewCell.self)"
                )!
                return cell

            }
        )
        dataSource.defaultRowAnimation = .fade
        applySnapShot()
    }

    func applySnapShot() {
        var snapShot = NSDiffableDataSourceSnapshot<
            Section, UITableViewDiffableDataSourceDemoCellItem
        >()
        snapShot.appendSections([.main])
        snapShot.appendItems(mainModels, toSection: .main)
        dataSource.apply(snapShot, animatingDifferences: true)
    }
}

extension UITableViewDiffableDataSourceDemoViewController:
    UITableViewDiffableDataSourceExpandCellDelegate
{
    func didTapExpand(_ cell: UITableViewDiffableDataSourceExpandCell) {
        guard let indexPath = tbView.indexPath(for: cell) else { return }
        // 取出对应数据，切换展开状态
        let item = mainModels[indexPath.row]
        if case .expand(var expandModel) = item {
            expandModel.isExpanded.toggle()
            mainModels[indexPath.row] = .expand(expandModel)

            applySnapShot()
        }

    }

}
