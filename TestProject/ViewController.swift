import SnapKit
import UIKit

final class ViewController: UIViewController, UIGestureRecognizerDelegate {
    private var doors: [Door] = []
    private var isSelectedCell = false
    
    private lazy var interImageView = UIImageView()
    private lazy var backSettingsView = UIView()
    private lazy var welcomeLbl = UILabel()
    private lazy var homeImageView = UIImageView()
    private lazy var myDoorsLbl = UILabel()
    private lazy var doorsTableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initialize()
    }
    
    private func initialize() {
        view.backgroundColor = .white
        addInter()
        addSettings()
        addDoorsTable()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
            guard let self else { return }
            self.doors = [Door(name: "Door 1", status: .locked, locationName: "Home"),
                          Door(name: "Door 2", status: .locked,locationName: "Work"),
                          Door(name: "Door 3", status: .locked, locationName: "Backdoor")]
            self.doorsTableView.reloadData()
        }
    }
    
    private func addInter() {
        interImageView.image = UIImage(named: "InterQR")
        view.addSubview(interImageView)
        
        interImageView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(49)
            $0.left.equalTo(view.snp.left).inset(24)
            $0.width.equalTo(86)
            $0.height.equalTo(17)
        }
    }
    
    private func addSettings() {
        backSettingsView.layer.cornerRadius = 13
        backSettingsView.layer.borderWidth = 1
        backSettingsView.layer.borderColor = #colorLiteral(red: 0.8901960784, green: 0.9176470588, blue: 0.9176470588, alpha: 1)
        
        view.addSubview(backSettingsView)
        backSettingsView.snp.makeConstraints {
            $0.right.equalTo(view.snp.right).inset(27)
            $0.width.height.equalTo(48)
            $0.centerY.equalTo(interImageView.snp.centerY)
        }
        
        let settingsImage = UIImage(named: "Setting")
        let settingsImageView = UIImageView(image: settingsImage)
        backSettingsView.addSubview(settingsImageView)
        settingsImageView.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
            $0.height.width.equalTo(21)
        }
    }
    private func addWelcomeLbl() {
        welcomeLbl.textColor = .black
        welcomeLbl.font =  UIFont(name: "Sk-Modernist-Bold", size: 35)
        welcomeLbl.text = "Welcome"
        view.addSubview(welcomeLbl)
        welcomeLbl.snp.makeConstraints{
            $0.top.equalTo(interImageView.snp.bottom).offset(63)
            $0.left.equalToSuperview().inset(24)
            $0.height.equalTo(35)
        }
    }
    
    private func addHome() {
        homeImageView.image = UIImage(named: "Home")
        view.addSubview(homeImageView)
        homeImageView.snp.makeConstraints{
            $0.top.equalTo(backSettingsView.snp.bottom)
            $0.right.equalTo(view.snp.right)
            $0.width.equalTo(185)
            $0.height.equalTo(168)
        }
    }
    
    private func addDoorsLbl() {
        myDoorsLbl.textColor = #colorLiteral(red: 0.1959999949, green: 0.2160000056, blue: 0.3330000043, alpha: 1)
        myDoorsLbl.font = UIFont(name: "Sk-Modernist-Bold", size: 20)
        myDoorsLbl.text = "My doors"
        view.addSubview(myDoorsLbl)
        myDoorsLbl.snp.makeConstraints {
            $0.top.equalTo(homeImageView.snp.bottom).offset(31)
            $0.left.equalToSuperview().inset(25)
        }
    }
    
    private func addDoorsTable() {
        view.addSubview(doorsTableView)
        doorsTableView.snp.makeConstraints {
            $0.top.equalTo(backSettingsView.snp.bottom)
            $0.left.right.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        doorsTableView.register(DoorTableViewCell.self, forCellReuseIdentifier: DoorTableViewCell.identifier)
        doorsTableView.dataSource = self
        doorsTableView.delegate = self
        doorsTableView.backgroundColor = .white
        doorsTableView.rowHeight = 117
        doorsTableView.separatorStyle = .none
        
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: doorsTableView.bounds.width, height: 216))
        welcomeLbl.textColor = .black
        welcomeLbl.font = UIFont(name: "Sk-Modernist-Bold", size: 35)
        welcomeLbl.text = "Welcome"
        headerView.addSubview(welcomeLbl)
        welcomeLbl.snp.makeConstraints{
            $0.top.equalToSuperview().offset(63)
            $0.left.equalToSuperview().inset(24)
            $0.height.equalTo(35)
        }
        
        homeImageView.image = UIImage(named: "Home")
        headerView.addSubview(homeImageView)
        homeImageView.snp.makeConstraints{
            $0.top.equalToSuperview()
            $0.right.equalTo(headerView.snp.right)
            $0.width.equalTo(185)
            $0.height.equalTo(168)
        }
        
        myDoorsLbl.textColor = #colorLiteral(red: 0.1959999949, green: 0.2160000056, blue: 0.3330000043, alpha: 1)
        myDoorsLbl.font = UIFont(name: "Sk-Modernist-Bold", size: 20)
        myDoorsLbl.text = "My doors"
        headerView.addSubview(myDoorsLbl)
        myDoorsLbl.snp.makeConstraints {
            $0.top.equalTo(homeImageView.snp.bottom).offset(0)
            $0.left.equalToSuperview().inset(25)
        }
        
        doorsTableView.tableHeaderView = headerView
    }
    
    private func unlockedLoop(indexPath: IndexPath) {
        if isSelectedCell { return }
        isSelectedCell = true
        
        let cell = doorsTableView.cellForRow(at: indexPath) as! DoorTableViewCell
        var door = doors[indexPath.row]
        door.status = .unlocking
        cell.doorsState = door.status
        doors[indexPath.row] = door
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [weak self] in
            guard let self else { return }
            
            door.status = .unlocked
            cell.doorsState = door.status
            self.doors[indexPath.row] = door
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [weak self] in
                guard let self else { return }
                
                door.status = .locked
                cell.doorsState = door.status
                self.doors[indexPath.row] = door
                self.isSelectedCell = false
            }
        }
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return doors.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = doorsTableView.dequeueReusableCell(withIdentifier: DoorTableViewCell.identifier, for: indexPath) as! DoorTableViewCell
        
        let door = doors[indexPath.row]
        cell.doorsState = door.status
        cell.doorName = door.name
        cell.locationName = door.locationName
        cell.indexPath = indexPath
        cell.lockedTap = { [weak self] indexPath in
            guard let self else { return }
            self.unlockedLoop(indexPath: indexPath)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        unlockedLoop(indexPath: indexPath)
    }
}
