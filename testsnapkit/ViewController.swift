import UIKit

// MARK: - 主视图控制器
class ViewController: UIViewController {
//    let
//
    var flexibleUICollectionView:FlexibleUICollectionView!

    let toggleButton = UIButton(type: .system)
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 设置按钮
        toggleButton.setTitle("提词器", for: .normal)
        toggleButton.frame = CGRect(x: 50, y: 80, width: 120, height: 40)
        toggleButton.addTarget(self, action: #selector(toggleCollectionView), for: .touchUpInside)
        view.addSubview(toggleButton)
        
        let backgroundImage = UIImageView(frame: view.bounds)
        backgroundImage.image = UIImage(named: "Image") // 确保图片存在于 Assets.xcassets
        backgroundImage.contentMode = .scaleAspectFill  // 根据需要可以用 .scaleAspectFit
        view.insertSubview(backgroundImage, at: 0)  // 放到最底层
    }
    
    // 点击按钮隐藏/显示
    @objc func toggleCollectionView() {
        if flexibleUICollectionView == nil{
            flexibleUICollectionView = FlexibleUICollectionView()
            addChild(flexibleUICollectionView)
            view.addSubview(flexibleUICollectionView.view)
            flexibleUICollectionView.didMove(toParent: self)
            
            view.bringSubviewToFront(toggleButton)
            return
        }
        let isHidden = flexibleUICollectionView.view.isHidden
        flexibleUICollectionView.view.isHidden = !isHidden
    }
}
