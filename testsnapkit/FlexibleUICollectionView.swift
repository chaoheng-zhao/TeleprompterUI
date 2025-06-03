import UIKit
import SnapKit



// MARK: - 自定义布局
class CustomCollectionViewLayout: UICollectionViewLayout {
    // 布局参数
    private let firstRowHeight: CGFloat = 40
    private let thirdRowHeight: CGFloat = 40
    private let padding: CGFloat = 0
    private let spacing: CGFloat = 0
    
    // 缓存布局属性
    private var layoutAttributes = [UICollectionViewLayoutAttributes]()
    
    override func prepare() {
        super.prepare()
        guard let collectionView = collectionView else { return }
        
        layoutAttributes.removeAll()
        
        // 第一行 (3个cell)
        for item in 0..<3 {
            let indexPath = IndexPath(item: item, section: 0)
            let attribute = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            
            let width = (collectionView.bounds.width - 2 * padding - 2 * spacing) / 3
            let x = padding + CGFloat(item) * (width + spacing)
            attribute.frame = CGRect(x: x, y: padding, width: width, height: firstRowHeight)
            
            layoutAttributes.append(attribute)
        }
        
        // 第二行 (1个cell)
        let secondRowIndexPath = IndexPath(item: 0, section: 1)
        let secondRowAttribute = UICollectionViewLayoutAttributes(forCellWith: secondRowIndexPath)
        
        let secondRowY = padding + firstRowHeight + spacing
        let secondRowHeight = collectionView.bounds.height - padding * 2 - firstRowHeight - thirdRowHeight - spacing * 2
        
        secondRowAttribute.frame = CGRect(
            x: padding,
            y: secondRowY,
            width: collectionView.bounds.width - 2 * padding,
            height: secondRowHeight
        )
        
        layoutAttributes.append(secondRowAttribute)
        
        // 第三行 (3个cell)
        for item in 0..<3 {
            let indexPath = IndexPath(item: item, section: 2)
            let attribute = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            
            let width = (collectionView.bounds.width - 2 * padding - 2 * spacing) / 3
            
            let x = padding + CGFloat(item) * (width + spacing)
            let y = collectionView.bounds.height - padding - thirdRowHeight
            
            attribute.frame = CGRect(x: x, y: y, width: width, height: thirdRowHeight)
           
            layoutAttributes.append(attribute)
        }
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return layoutAttributes.filter { $0.frame.intersects(rect) }
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return layoutAttributes.first { $0.indexPath == indexPath }
    }
    
    override var collectionViewContentSize: CGSize {
        guard let collectionView = collectionView else { return .zero }
        return CGSize(
            width: collectionView.bounds.width,
            height: collectionView.bounds.height
        )
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
}


class TextViewCell:UICollectionViewCell {
    // 定义标识符
    static let identifier = "TextViewCell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    required init?(coder:NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setupUI() {
        // 设置TextViewCell的UI
//        backgroundColor = .systemBlue
        layer.cornerRadius = 12
        layer.borderWidth = 1
        layer.borderColor = UIColor.white.cgColor
        // 2. 创建UITextView替换UILabel
        let textView = UITextView()
        textView.text = "欢迎使用提词器" // 默认文本
        textView.textColor = .white
        textView.font = .boldSystemFont(ofSize: 16)
        textView.isEditable = true // 禁止编辑（如需可编辑则设为true）
        textView.backgroundColor = UIColor.black.withAlphaComponent(0.1)
        textView.layer.cornerRadius = 10
        contentView.addSubview(textView)
        textView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    
}
class ButtonCell:UICollectionViewCell {
    static let identifier = "ButtonCell"
    
    override init(frame: CGRect){
        super.init(frame: frame)
        setupUI()

    }
    required init?(coder:NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setupUI() {
        // 设置TextViewCell的UI
        layer.cornerRadius = 12
        layer.borderWidth = 1
        layer.borderColor = UIColor.white.cgColor
        
        let button = UIButton()
        button.setTitle("增大字体", for: .normal)
        button.backgroundColor = .systemBlue
        contentView.addSubview(button)
        button.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}


// MARK: - 单元格
class CustomCollectionViewCell: UICollectionViewCell {
    static let identifier = "CustomCollectionViewCell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setupUI() {
        backgroundColor = .systemBlue
        layer.cornerRadius = 12
        layer.borderWidth = 1
        layer.borderColor = UIColor.white.cgColor
        
        let label = UILabel()
        label.text="UI"
        label.textColor = .white
        label.font = .boldSystemFont(ofSize: 16)
        label.textAlignment = .center
        contentView.addSubview(label)
        label.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        // 设置标签文本
        if let section = indexPath?.section {
            label.text = "Section \(section)"
        }
    }
    
    // 获取当前cell的indexPath，indexPath中包含section（行）和item（列）
    private var indexPath: IndexPath? {
        return (superview as? UICollectionView)?.indexPath(for: self)
    }
}

class FlexibleUICollectionView: UIViewController{
    private var collectionView: UICollectionView!
    private var resizeHandle: UIView!
    private var containerView: UIView!
    private var initialTouchPoint: CGPoint = .zero
    private var initialSize: CGSize = .zero
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupContainerView()
        setupCollectionView()
        setupResizeHandle()
        setupDraggable()
    }
    
    private func setupContainerView() {
        containerView = UIView()
        containerView.backgroundColor = .lightGray
        containerView.layer.cornerRadius = 16
        containerView.clipsToBounds = true
        view.addSubview(containerView)
        
        
        
        containerView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(300)
            make.height.equalTo(400)
        }
    }
    
    private func setupCollectionView() {
        let layout = CustomCollectionViewLayout()
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        
        collectionView.register(CustomCollectionViewCell.self, forCellWithReuseIdentifier: CustomCollectionViewCell.identifier)
        
        collectionView.register(TextViewCell.self,
                        forCellWithReuseIdentifier: TextViewCell.identifier)
        
        collectionView.register(ButtonCell.self,
                        forCellWithReuseIdentifier: ButtonCell.identifier)
        
        collectionView.dataSource = self
        containerView.addSubview(collectionView)
        
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    // 设置手势拖拽
    private func setupResizeHandle() {
        resizeHandle = UIView()
        resizeHandle.backgroundColor = .darkGray
        resizeHandle.layer.cornerRadius = 8
        containerView.addSubview(resizeHandle)
        
        resizeHandle.snp.makeConstraints { make in
            make.width.height.equalTo(16)
            make.bottom.trailing.equalToSuperview().inset(8)
        }
        
        // 添加拖拽手势
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handleResizeGesture(_:)))
        
        resizeHandle.addGestureRecognizer(panGesture)
    }
    
    @objc private func handleResizeGesture(_ gesture: UIPanGestureRecognizer) {
        let touchPoint = gesture.location(in: view)
        
        switch gesture.state {
        case .began:
            initialTouchPoint = touchPoint
            initialSize = containerView.frame.size
            
        case .changed:
            let deltaX = touchPoint.x - initialTouchPoint.x
            let deltaY = touchPoint.y - initialTouchPoint.y
            
            let newWidth = max(100, initialSize.width + deltaX)
            let newHeight = max(150, initialSize.height + deltaY)
            
            containerView.snp.updateConstraints { make in
                make.width.equalTo(newWidth)
                make.height.equalTo(newHeight)
            }
            
            // 立即刷新布局
            view.setNeedsLayout()
            view.layoutIfNeeded()
            // 强制CollectionView重绘
            collectionView.collectionViewLayout.invalidateLayout()
            
        default:
            break
        }
    }
    // 设置手势移动
    func setupDraggable() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(dragged(_:)))
        self.containerView.addGestureRecognizer(panGesture)
    }
    @objc func dragged(_ sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: view.superview)
        if let view = sender.view {
            view.center = CGPoint(
                x: view.center.x + translation.x,
                y: view.center.y + translation.y)
        }
        sender.setTranslation(.zero, in: view.superview)
    }
    
}

// MARK: - 数据源
extension FlexibleUICollectionView: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3 // 三行
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
            case 0: return 3 // 第一行3个
            case 1: return 1 // 第二行1个
            case 2: return 3 // 第三行3个
            default: return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 1{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TextViewCell.identifier, for: indexPath) as! TextViewCell
            return cell
        }
        if indexPath.section == 2 && indexPath.item==1{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ButtonCell.identifier, for: indexPath) as! ButtonCell
            return cell
        }
        
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: CustomCollectionViewCell.identifier,
            for: indexPath
        ) as! CustomCollectionViewCell
        
        // 根据部分设置不同颜色
        switch indexPath.section {
            case 0: cell.backgroundColor = .systemRed
            case 1: cell.backgroundColor = .systemGreen
            case 2: cell.backgroundColor = .systemPurple
            default: break
        }
        return cell
    }
}
