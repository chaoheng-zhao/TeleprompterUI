import UIKit

// MARK: - 主视图控制器
class ViewController: UIViewController {
//    let
    let flexibleUICollectionView = FlexibleUICollectionView()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addChild(flexibleUICollectionView)
        view.addSubview(flexibleUICollectionView.view)
        flexibleUICollectionView.didMove(toParent: self)
        
//        addChild(uiExample)
//        view.addSubview(uiExample.view)
//        uiExample.didMove(toParent: self)
    }
}
