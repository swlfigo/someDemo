//
//  ViewController.swift
//  TableviewAutolayoutDemo
//
//  Created by sylar on 2025/5/31.
//

import UIKit
import SnapKit

let loremText = "Lorem ipsum dolor sit amet consectetur adipiscing elit. Quisque faucibus ex sapien vitae pellentesque sem placerat. In id cursus mi pretium tellus duis convallis. Tempus leo eu aenean sed diam urna tempor. Pulvinar vivamus fringilla lacus nec metus bibendum egestas. Iaculis massa nisl malesuada lacinia integer nunc posuere. Ut hendrerit semper vel class aptent taciti sociosqu. Ad litora torquent per conubia nostra inceptos himenaeos.Lorem ipsum dolor sit amet consectetur adipiscing elit. Quisque faucibus ex sapien vitae pellentesque sem placerat. In id cursus mi pretium tellus duis convallis. Tempus leo eu aenean sed diam urna tempor. Pulvinar vivamus fringilla lacus nec metus bibendum egestas. Iaculis massa nisl malesuada lacinia integer nunc posuere. Ut hendrerit semper vel class aptent taciti sociosqu. Ad litora torquent per conubia nostra inceptos himenaeos."


class ViewController: UIViewController {

    var tbView : UITableView = UITableView(frame: .zero, style: .plain)
    
    var dataSource : [Any] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        do {
            let attr1 = generateAttribute()
            let wrapperModel = Style1Wrapper(attributeStr: attr1)
            dataSource.append(wrapperModel)
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
        tbView.register(Style1Cell.self , forCellReuseIdentifier: "\(Style1Cell.self)")
        tbView.register(Style2Cell.self , forCellReuseIdentifier: "\(Style2Cell.self)")
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

extension ViewController : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = dataSource[indexPath.row]
        if let _ = data as? Style1Wrapper {
            let cell = tableView.dequeueReusableCell(withIdentifier: "\(Style1Cell.self)") as! Style1Cell
            cell.wrapperModel = data as? Style1Wrapper
            return cell
        }else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "\(Style2Cell.self)") as! Style2Cell
            return cell
        }
    }
    
}
