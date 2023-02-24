import UIKit
import SnapKit

final class DoorTableViewCell: UITableViewCell {
    static let identifier: String = String(describing: DoorTableViewCell.self)
    
    private lazy var backView:UIView! = UIView()
    private lazy var backImageView:UIView! = UIView()
    private lazy var doorImageView:UIImageView! = UIImageView()
    private lazy var doorNameLbl:UILabel! = UILabel()
    private lazy var doorLocate:UILabel! = UILabel()
    private lazy var stateImageView:UIImageView! = UIImageView()
    private lazy var doorState :UILabel = UILabel()
    
    private lazy var lockColors = [
        UIColor(named: "LockedColor")?.cgColor,
        UIColor(named: "LockedEndColor")?.cgColor
    ]
    
    private lazy var unlockColors = [
        UIColor(named: "UnlockedStartColor")?.cgColor,
        UIColor(named: "UnlockedEndColor")?.cgColor
    ]
    
    private var lockedConstraint: Constraint!
    private var unlockingConstraint: Constraint!
    
    var indexPath: IndexPath!
    
    var doorName = "" {
        didSet {
            doorNameLbl.text = doorName
        }
    }
    
    var locationName = "" {
        didSet {
            doorLocate.text = locationName
        }
    }
    
    var lockedTap: ((IndexPath)->())?
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        doorsState = .locked
        doorName = ""
        locationName = ""
        doorImageView.image = nil
        stateImageView.image = nil
        doorState.textColor = #colorLiteral(red: 0, green: 0.2669999897, blue: 0.5450000167, alpha: 1)
        removeGradient()
    }
    
    var doorsState = DoorStatus.locked {
        didSet {
            layoutIfNeeded()
            switch doorsState {
            case .locked:
                addGradientLayer()
                updateDoorImageConstraints()
                doorImageView.image = #imageLiteral(resourceName: "Verify")
                stateImageView.image = #imageLiteral(resourceName: "Locked.png")
                doorState.textColor = #colorLiteral(red: 0, green: 0.2669999897, blue: 0.5450000167, alpha: 1)
                stateImageView.contentMode = .scaleAspectFit
                stateImageView?.layer.removeAllAnimations()
            case .unlocked:
                addGradientLayer()
                updateDoorImageConstraints()
                doorImageView.image = #imageLiteral(resourceName: "Blocked")
                stateImageView.image = #imageLiteral(resourceName: "Unlocked")
                doorState.textColor = #colorLiteral(red: 0, green: 0.2666666667, blue: 0.5450980392, alpha: 0.5)
                stateImageView.contentMode = .scaleAspectFit
                stateImageView?.layer.removeAllAnimations()
            case .unlocking:
                removeGradient()
                doorImageView.image = #imageLiteral(resourceName: "Dots")
                lockedConstraint.deactivate()
                doorImageView.snp.makeConstraints {
                    unlockingConstraint = $0.centerX.centerY.equalTo(backImageView).constraint
                }
                unlockingConstraint.activate()
                stateImageView.contentMode = .topLeft
                addAnimation()
                stateImageView.image = #imageLiteral(resourceName: "Spinner")
                doorState.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.17)
            }
            doorState.text = doorsState.rawValue
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addGradientLayer() {
        removeGradient()
        
        let layer = CAGradientLayer()
        layer.colors = doorsState == .locked ? lockColors : unlockColors
        layer.locations = [0, 1]
        layer.startPoint = CGPoint(x: 0.25, y: 0.5)
        layer.endPoint = CGPoint(x: 0.75, y: 0.5)
        layer.transform = CATransform3DMakeAffineTransform(CGAffineTransform(a: 1.17, b: 0.68, c: -0.68, d: 7.16, tx: 0.5, ty: -3.45))
        layer.bounds = backImageView.bounds.insetBy(dx: -0.5 * backImageView.bounds.size.width, dy: -0.5 * backImageView.bounds.size.height)
        layer.position = backImageView.center
        backImageView.layer.insertSublayer(layer, at: 0)
    }
    
    private func removeGradient() {
        if backImageView.layer.sublayers!.count > 1 {
            backImageView.layer.sublayers![0].removeFromSuperlayer()
        }
    }
    
    private func addAnimation() {
        let animation = CABasicAnimation(keyPath: "transform.rotation.z")
        animation.duration = 0.75
        animation.toValue = CGFloat.pi * 2.0
        animation.repeatCount = .infinity
        stateImageView?.layer.add(animation, forKey: "rotationAnimation")
    }
    
    private func updateDoorImageConstraints() {
        unlockingConstraint?.deactivate()
        doorImageView.snp.makeConstraints{
            lockedConstraint = $0.left.top.equalToSuperview().inset(12).constraint
        }
        lockedConstraint.activate()
    }
    
    private func configure() {
        selectionStyle = .none
        backView.frame.size = CGSize(width: contentView.bounds.height, height: contentView.bounds.width)
        
        addSubview(backView)
        backView.snp.makeConstraints{
            $0.left.right.equalToSuperview().inset(27)
            $0.top.bottom.equalToSuperview().inset(7)
        }
        backView.layer.cornerRadius = 15
        backView.layer.borderWidth = 1
        backView.layer.borderColor = #colorLiteral(red: 0.8901960784, green: 0.9176470588, blue: 0.9176470588, alpha: 1)
        backView.addSubview(backImageView)
        
        backImageView.snp.makeConstraints{
            $0.height.width.equalTo(41)
            $0.top.equalTo(18)
            $0.left.equalTo(27)
        }
        
        backImageView.layer.cornerRadius = 20.5
        backImageView.clipsToBounds = true
        backImageView.backgroundColor = #colorLiteral(red: 0.7254901961, green: 0.7254901961, blue: 0.7254901961, alpha: 1)
        backImageView.addSubview(doorImageView)
        
        doorImageView.image = #imageLiteral(resourceName: "Verify.png")
        doorImageView.contentMode = .center
        updateDoorImageConstraints()
        backView.addSubview(doorNameLbl)
        doorNameLbl.textColor = #colorLiteral(red: 0.1960784314, green: 0.2156862745, blue: 0.3333333333, alpha: 1)
        doorNameLbl.font = UIFont(name: "Sk-Modernist-Bold", size: 16)
        doorNameLbl.snp.makeConstraints{
            $0.top.equalTo(22)
            $0.left.equalTo(backImageView.snp.right).offset(14)
        }
        
        backView.addSubview(doorLocate)
        doorLocate.font = UIFont(name: "Sk-Modernist-Regular", size: 14)
        doorLocate.textColor = #colorLiteral(red: 0.7254901961, green: 0.7254901961, blue: 0.7254901961, alpha: 1)
        doorLocate.snp.makeConstraints{
            $0.top.equalTo(doorNameLbl.snp.bottom)
            $0.left.equalTo(doorNameLbl.snp.left)
        }
        
        backView.addSubview(stateImageView)
        stateImageView.snp.makeConstraints{
            $0.top.equalToSuperview().inset(18)
            $0.right.equalToSuperview().inset(28)
        }
        
        stateImageView.image = #imageLiteral(resourceName: "Unlocked")
        stateImageView.contentMode = .topRight
        
        backView.addSubview(doorState)
        doorState.snp.makeConstraints{
            $0.bottom.equalTo(backView.snp.bottom).inset(11)
            $0.centerX.equalToSuperview()
        }
        doorState.text = DoorStatus.locked.rawValue
        doorState.textColor = .black
        doorState.font = UIFont(name: "Sk-Modernist-Bold", size: 15)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(lockedClick(_:)))
        tapGesture.cancelsTouchesInView = false
        doorState.isUserInteractionEnabled = true
        doorState.addGestureRecognizer(tapGesture)
    }
    
    @objc func lockedClick(_ sender: UITapGestureRecognizer){
       lockedTap?(indexPath)
    }
}
