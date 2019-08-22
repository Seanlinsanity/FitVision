//
//  AccountWorkoutCell.swift
//  FitVisionFirebase
//
//  Created by SEAN on 2018/4/8.
//  Copyright © 2018年 SEAN. All rights reserved.
//

import UIKit
import Firebase

class AccountWorkoutCell: BaseCell, UITableViewDelegate, UITableViewDataSource{
    
    var accountController: AccountController?
    var workouts: [Workout]?{
        didSet{
            tableView.reloadData()
        }
    }
    
    let cellId = "cellId"
    let backView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let workoutTitle: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.text = "我的每週健身規劃"
        label.textColor = UIColor.lightGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let tableView: UITableView = {
        let tv = UITableView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    lazy var addButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(named: "add_workout")
        button.setImage(image?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.imageView?.contentMode = .scaleAspectFill
        button.setTitle(" 新增計畫", for: .normal)
        button.setTitleColor(UIColor.mainGreen, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.layer.cornerRadius = 6
        button.clipsToBounds = true
        button.layer.borderColor = UIColor.mainGreen.cgColor
        button.layer.borderWidth = 1
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.addTarget(self, action: #selector(handleAdd), for: .touchUpInside)
        return button
    }()
    
    private func setupTableView(){
        tableView.estimatedRowHeight = 0
        tableView.estimatedSectionHeaderHeight = 0
        tableView.estimatedSectionFooterHeight = 0
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorColor = .clear
        tableView.register(WorkoutCell.self, forCellReuseIdentifier: cellId)
    }
    
    override func setupViews() {
        super.setupViews()
        setupTableView()
        backgroundColor = UIColor.rgb(red: 230, green: 230, blue: 230, alpha: 1)

        addSubview(backView)
        backView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        backView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        backView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        backView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12).isActive = true
        
        addSubview(workoutTitle)
        workoutTitle.topAnchor.constraint(equalTo: topAnchor, constant: 24).isActive = true
        workoutTitle.leftAnchor.constraint(equalTo: leftAnchor, constant: 40).isActive = true
        workoutTitle.widthAnchor.constraint(equalToConstant: 200).isActive = true
        workoutTitle.heightAnchor.constraint(equalToConstant: 24).isActive = true
        
        addSubview(addButton)
        addButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -24).isActive = true
        addButton.leftAnchor.constraint(equalTo: leftAnchor, constant: 36).isActive = true
        addButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -36).isActive = true
        addButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        addSubview(tableView)
        tableView.topAnchor.constraint(equalTo: workoutTitle.bottomAnchor, constant: 12).isActive = true
        tableView.bottomAnchor.constraint(equalTo: addButton.topAnchor, constant: -12).isActive = true
        tableView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
    }
    
    func handleDelete(indexPath: IndexPath){
        let workout = workouts?[indexPath.section]
        guard let uid = Auth.auth().currentUser?.uid else { return }
        guard let day = workout?.day else { return }
        
        workouts?.remove(at: indexPath.section)
        tableView.reloadData()
        accountController?.handleDeleteWorkout(workouts: workouts)

        Database.database().reference().child("users-workout").child(uid).child(day).removeValue { (error, ref) in
            if error != nil {
                print("remove workout error")
                return
            }
        }
    }
    
    private func handleEdit(indexPath: IndexPath){
        let workout = workouts?[indexPath.section]
        let addWorkoutController = AddWorkoutController()
        addWorkoutController.workout = workout
        addWorkoutController.originalWorkoutDay = workout?.day
        let navigationController = UINavigationController(rootViewController: addWorkoutController)
        accountController?.present(navigationController, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .destructive, title: "刪除") { (_, indexPath) in
            self.handleDelete(indexPath: indexPath)
        }
        return [deleteAction]
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return workouts?.count ?? 0
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 12
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! WorkoutCell
        cell.workout = workouts?[indexPath.section]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        handleEdit(indexPath: indexPath)
    }
    
    @objc private func handleAdd(){
        let addWorkoutController = AddWorkoutController()
        let navigationController = UINavigationController(rootViewController: addWorkoutController)
        accountController?.present(navigationController, animated: true, completion: nil)
    }

    @available(iOS 11.0, *)
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let edit = UIContextualAction(style: .normal, title: "編輯") { (action, view, _) in
            self.handleEdit(indexPath: indexPath)
        }
        edit.backgroundColor = .mainGreen 
        return UISwipeActionsConfiguration(actions: [edit])

    }

    @available(iOS 11.0, *)
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive, title: "刪除") { (action, view, _) in
            self.handleDelete(indexPath: indexPath)
        }
        return UISwipeActionsConfiguration(actions: [delete])
    }
    
    
}
