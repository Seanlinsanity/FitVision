//
//  AllCategoriesController.swift
//  FitVisionFirebase
//
//  Created by SEAN on 2018/5/13.
//  Copyright © 2018年 SEAN. All rights reserved.
//

import UIKit

class Category: NSObject{
    
    let type: CategoryType
    let items: [String]
    
    init(type: CategoryType, items: [String]) {
        self.type = type
        self.items = items
    }
}

enum CategoryType: String{
    case difficulties = "難易程度"
    case muscleGroups = "訓練肌群"
    case fittnessRoom = "健身教室"
    case more = "更多分類"
}

class IndentedLabel: UILabel {
    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsetsMake(0, 16, 0, 0)
        let customRect = UIEdgeInsetsInsetRect(rect, insets)
        super.drawText(in: customRect)
    }
}

class AllCategoriesController: UITableViewController{
    
    let cellId = "cellId"
    var homeController: HomeController?
    
    let categories = [
        Category(type: .difficulties, items: ["初階", "進階", "高階"]),
        Category(type: .muscleGroups, items: ["胸肌", "背肌", "腹肌", "腿部", "臀部", "肩膀", "手臂"]),
        Category(type: .fittnessRoom, items: ["飲食", "知識"]),
        Category(type: .more, items: ["女孩專區", "間歇訓練"])
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 20), NSAttributedStringKey.foregroundColor: UIColor.white]
        navigationController?.navigationBar.tintColor = .white
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "返回", style: .plain, target: self, action: #selector(handleDismiss))
        
        tableView.backgroundColor = .white
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return categories.count
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = IndentedLabel()
        label.text = categories[section].type.rawValue
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.backgroundColor = .lightGray
        label.textColor = .white
        return label
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories[section].items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath)
        cell.textLabel?.text = categories[indexPath.section].items[indexPath.row]
        cell.textLabel?.font = UIFont.systemFont(ofSize: 18)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dismiss(animated: true) {
            let category = self.categories[indexPath.section].items[indexPath.row]
            self.homeController?.handleMoreCategoryVideos(category: category)
        }
    }
    
    @objc private func handleDismiss(){
        dismiss(animated: true, completion: nil)
    }
    
}
