//
//  ViewController.swift
//  someDemo
//
//  Created by sylar on 2025/6/24.
//

import SnapKit
import UIKit

class SomeDemoEntryPointViewController: UIViewController {
    private var theTableView: UITableView = UITableView.init(frame: .zero, style: .plain)

    private let source: [DemoVCInitialParams] = [
        DemoVCInitialParams(
            name: "Metal三角形",
            vcCls: "UITableViewAutolayoutDemoViewController"
        ),
        DemoVCInitialParams(
            name: "TableViewAutoLayout",
            vcCls: "UITableViewAutolayoutDemoViewController"
        ),
        DemoVCInitialParams(name: "TableView Diff", vcCls: "UITableViewDiffableDataSourceDemoViewController"),
        DemoVCInitialParams(name: "TagView", vcCls: "UICollectionViewTagViewController"),
        DemoVCInitialParams(name: "UICollectionViewAutoLayout", vcCls: "UICollectionviewAutoLayoutViewController")
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        navigationItem.title = "Main"

        self.view.addSubview(theTableView)
        theTableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        theTableView.delegate = self
        theTableView.dataSource = self
        theTableView.register(
            UITableViewCell.self,
            forCellReuseIdentifier: "\(UITableViewCell.self)"
        )
        UITableViewCell.appearance().selectionStyle = .none
    }

}

extension SomeDemoEntryPointViewController: UITableViewDataSource,
    UITableViewDelegate
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int)
        -> Int
    {
        return source.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath)
        -> UITableViewCell
    {
        let vcParam = source[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "\(UITableViewCell.self)")!
        cell.textLabel?.text = vcParam.name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vcParam = source[indexPath.row]
        
        let moduleName = Bundle.main.infoDictionary!["CFBundleName"] as! String
        let cls:AnyClass? = NSClassFromString("\(moduleName).\(vcParam.vcCls)")
        // 将AnyClass转为指定的类型
        if let vcCls = cls as? SomeDemoBaseViewController.Type {
            let vc = vcCls.init()
            vc.paramDic = vcParam.params
            navigationController?.pushViewController(vc, animated: true)
        }

        
    }
}
