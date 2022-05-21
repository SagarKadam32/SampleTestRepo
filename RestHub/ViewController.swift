//
//  ViewController.swift
//  RestHub
//
//  Created by Sagar Kadam on 15/05/22.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var feedTableView: UITableView!
    var feedGists:[Gist] = []

    override func viewDidLoad() {
        super.viewDidLoad()
//        let testGist = Gist(id: nil, isPublic: true, description: "Hello World!", files: nil)
//
//        do{
//            let gistData = try JSONEncoder().encode(testGist)
//            let stringData = String(data: gistData, encoding: .utf8)
//            print(stringData)
//        }catch{
//            print("Encoding Failed...")
//        }
        
        DataService.shared.fetchGists { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let gists):
                    self.feedGists = gists
                    self.feedTableView.reloadData()
                    for gist in gists {
                        print("\(gist)\n")
                    }
                case .failure(let error):
                    print(error)
                }
            }
        }
    }

    @IBAction func newGistButtonClicked(_ sender: Any) {
        DataService.shared.createNewGist { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let json):
                    self.showAlert(title: "Yay!!", message: "New Post Sucessfully Created!")
                case .failure(let error):
                    self.showAlert(title: "Oops..", message: "Something went wrong..")
                }
            }
        }
    }
    
    func showAlert(title: String, message:String){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: .default))
        self.present(alertController, animated: true, completion: nil)
    }
}

extension ViewController : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.feedGists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let currentGist = self.feedGists[indexPath.row]
        cell.textLabel?.text = currentGist.description
        cell.detailTextLabel?.text = currentGist.id
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let currentGist = self.feedGists[indexPath.row]
        let starAction = UIContextualAction(style: .normal, title: "Star") { (action, view, completion) in
            DataService.shared.starUnstarGist(id: currentGist.id ?? "", star: true) { success in
                DispatchQueue.main.async {
                    if success {
                        self.showAlert(title: "Success", message: "Gist Successfully Starred!!")
                    }else{
                        self.showAlert(title: "Failure", message: "Gist was not able to be starred..")
                    }
                }
            }
            completion(true)
        }
        
        let unStarAction = UIContextualAction(style: .normal, title: "Un-Star") { (action, view, completion) in
            DataService.shared.starUnstarGist(id: currentGist.id ?? "", star: false) { success in
                DispatchQueue.main.async {
                    if success {
                        self.showAlert(title: "Success", message: "Gist Successfully Un-Starred!!")
                    }else{
                        self.showAlert(title: "Failure", message: "Gist was not able to be Un-starred..")
                    }
                }
            }
            completion(true)
        }
        starAction.backgroundColor = .blue
        unStarAction.backgroundColor = .gray
        let actionConfig = UISwipeActionsConfiguration(actions: [starAction,unStarAction])
        return actionConfig
    }
}

