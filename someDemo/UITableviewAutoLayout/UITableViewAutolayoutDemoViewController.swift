//
//  UITableViewAutolayoutDemoeViewController.swift
//  someDemo
//
//  Created by sylar on 2025/6/24.
//

import Foundation
import UIKit
import SnapKit

let loremText = "Lorem ipsum dolor sit amet consectetur adipiscing elit. Quisque faucibus ex sapien vitae pellentesque sem placerat. In id cursus mi pretium tellus duis convallis. Tempus leo eu aenean sed diam urna tempor. Pulvinar vivamus fringilla lacus nec metus bibendum egestas. Iaculis massa nisl malesuada lacinia integer nunc posuere. Ut hendrerit semper vel class aptent taciti sociosqu. Ad litora torquent per conubia nostra inceptos himenaeos.Lorem ipsum dolor sit amet consectetur adipiscing elit. Quisque faucibus ex sapien vitae pellentesque sem placerat. In id cursus mi pretium tellus duis convallis. Tempus leo eu aenean sed diam urna tempor. Pulvinar vivamus fringilla lacus nec metus bibendum egestas. Iaculis massa nisl malesuada lacinia integer nunc posuere. Ut hendrerit semper vel class aptent taciti sociosqu. Ad litora torquent per conubia nostra inceptos himenaeos."



class UITableViewAutolayoutDemoViewController : SomeDemoBaseViewController {
    
    var tbView : UITableView = UITableView(frame: .zero, style: .plain)
    
    var dataSource : [Any] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        dataSource = Array(repeating:  UITableViewAutoLayoutStyle2Wrapper(), count: 20)
        do {
            let attr1 = generateAttribute()
            let wrapperModel = UITableViewAutoLayoutStyle1Wrapper(attributeStr: attr1)
            dataSource[1] = wrapperModel
        }
        do {
            let attr1 = generateAttribute()
            let wrapperModel = UITableViewAutoLayoutStyle1Wrapper(attributeStr: attr1)
            dataSource[3] = wrapperModel
        }
       
        
        self.view.addSubview(tbView)
        tbView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.center.equalToSuperview()
        }
        tbView.estimatedRowHeight = UITableView.automaticDimension
        tbView.estimatedSectionFooterHeight = UITableView.automaticDimension
        tbView.estimatedSectionHeaderHeight = UITableView.automaticDimension
        // 自动计算行高
        tbView.register(UITableViewAutoLayoutStyle1Cell.self , forCellReuseIdentifier: "\(UITableViewAutoLayoutStyle1Cell.self)")
        tbView.register(UITableViewAutoLayoutStyle2Cell.self , forCellReuseIdentifier: "\(UITableViewAutoLayoutStyle2Cell.self)")
        tbView.delegate = self
        tbView.dataSource = self
        tbView.reloadData()
    }

    func generateAttribute() -> NSAttributedString {
        let attText = NSMutableAttributedString.init(string: loremText)
        let paragraph = NSMutableParagraphStyle()
        paragraph.lineSpacing = 2
        attText.addAttributes([
            .foregroundColor:UIColor.black,
            .font:UIFont.systemFont(ofSize: 14),
            .paragraphStyle:paragraph
        ], range: NSRange(location: 0, length: attText.length))
        return NSAttributedString.init(attributedString: attText)
    }
    
}


extension UITableViewAutolayoutDemoViewController : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = dataSource[indexPath.row]
        if let _ = data as? UITableViewAutoLayoutStyle1Wrapper {
            let cell = tableView.dequeueReusableCell(withIdentifier: "\(UITableViewAutoLayoutStyle1Cell.self)") as! UITableViewAutoLayoutStyle1Cell
            cell.wrapperModel = data as? UITableViewAutoLayoutStyle1Wrapper
            return cell
        }else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "\(UITableViewAutoLayoutStyle2Cell.self)") as! UITableViewAutoLayoutStyle2Cell
            return cell
        }
    }
    
}

