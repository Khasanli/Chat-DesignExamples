//
//  NewConversationViewController.swift
//  DesignExamples
//
//  Created by Samir Hasanli on 03.07.21.
//

import UIKit
import JGProgressHUD

class NewConversationViewController: UIViewController {
    private let spinner = JGProgressHUD(style: .light)
    private var users = [[String: String]]()
    private var results = [SearchResult]()
    public var completion: ((SearchResult) -> (Void))?
    private var hasFetched = false
    
    let noResultFound : UILabel = {
        let label = UILabel()
        label.isHidden = true
        label.text = "No Contacts were found!!"
        label.textAlignment = .center
        label.textColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        return label
    }()
    let searchBar : UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Search contacts!"
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        return searchBar
    }()
    let tableView : UITableView = {
        let tableView = UITableView()
        tableView.isHidden = true
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        view.backgroundColor = .white
        view.addSubview(searchBar)
        view.addSubview(tableView)
        searchBar.becomeFirstResponder()
        
        tableView.delegate = self
        tableView.dataSource = self
        setSubviews()
    }
    private func setSubviews(){
        searchBar.topAnchor.constraint(equalTo: view.topAnchor, constant: view.height/32).isActive = true
        searchBar.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        searchBar.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        searchBar.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 1/16).isActive = true
        
        tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor).isActive = true
        tableView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        tableView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        tableView.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
    }
}
extension NewConversationViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text, !text.isEmpty, !text.replacingOccurrences(of: " ", with: "").isEmpty else {
            return
        }
        results.removeAll()
        spinner.show(in: view)
        self.searchContacts(query: text)
    }
    func searchContacts(query: String){
        if hasFetched {
            filterUsers(with: query)
        }else {
            DatabaseManager.shared.getAllUsers { [weak self] result in
                switch result  {
                case .success(let userCollection):
                    self?.hasFetched = true
                    self?.users = userCollection
                    self?.filterUsers(with: query)
                case .failure(let err):
                    print(err.localizedDescription)
                }
            }
        }
    }
    
    func filterUsers(with term: String){
        guard let currentUserEmail = UserDefaults.standard.value(forKey: "email") as? String, hasFetched else {
                    return
                }
        let safeEmail = DatabaseManager.safeEmail(email_adress: currentUserEmail)
        self.spinner.dismiss()
        
        let results: [SearchResult] = users.filter({
                    guard let email = $0["email"], email != safeEmail else {
                        return false
                    }
                    guard let name = $0["name"]?.lowercased() else {
                        return false
                    }
                    return name.hasPrefix(term.lowercased())
                }).compactMap({
                    guard let email = $0["email"],
                        let name = $0["name"] else {
                        return nil
                    }
                    return SearchResult(name: name, email: email)
                })
        self.results = results
        updateUI()
    }
    func updateUI(){
        if results.isEmpty {
            self.noResultFound.isHidden = false
            self.tableView.isHidden = true
        }else {
            self.noResultFound.isHidden = true
            self.tableView.isHidden = false
            self.tableView.reloadData()
        }
    }
}
extension NewConversationViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = results[indexPath.row].name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let targetUserData = results[indexPath.row]
        dismiss(animated: true, completion: { [weak self] in
                    self?.completion?(targetUserData)
        })
    }
}
