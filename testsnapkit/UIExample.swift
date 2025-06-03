import UIKit
import SnapKit

class UIExample: UIViewController {
    
    // MARK: - UI Elements
    private var collectionView: UICollectionView!
    
    // 存储每个cell的文本内容
    private var textContents: [String] = Array(repeating: "", count: 10)
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        title = "TextView + Button in Cells"
    }
    
    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: view.bounds.width - 40, height: 150)
        layout.minimumLineSpacing = 20
        layout.sectionInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.register(TextButtonCell.self, forCellWithReuseIdentifier: "TextButtonCell")
        collectionView.dataSource = self
        collectionView.delegate = self
        view.addSubview(collectionView)
        
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

// MARK: - CollectionView DataSource & Delegate
extension UIExample: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return textContents.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TextButtonCell", for: indexPath) as! TextButtonCell
        
        // 配置cell
        cell.configure(text: textContents[indexPath.item])
        
        // 按钮点击回调
        cell.buttonAction = { [weak self] in
            self?.handleButtonTap(at: indexPath)
        }
        
        // 文本变化回调
        cell.textChangedAction = { [weak self] newText in
            self?.textContents[indexPath.item] = newText
        }
        
        return cell
    }
    
    private func handleButtonTap(at indexPath: IndexPath) {
        let alert = UIAlertController(title: "按钮点击",
                                    message: "点击了第\(indexPath.item + 1)个单元格的按钮",
                                    preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "确定", style: .default))
        present(alert, animated: true)
    }
}

// MARK: - 自定义Cell
class TextButtonCell: UICollectionViewCell {
    
    // MARK: - UI Elements
    let textView: UITextView = {
        let tv = UITextView()
        tv.font = .systemFont(ofSize: 16)
        tv.layer.borderWidth = 1
        tv.layer.borderColor = UIColor.lightGray.cgColor
        tv.layer.cornerRadius = 8
        tv.textContainerInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        return tv
    }()
    
    let button: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("提交内容", for: .normal)
        btn.backgroundColor = .systemBlue
        btn.setTitleColor(.white, for: .normal)
        btn.layer.cornerRadius = 8
        return btn
    }()
    
    // MARK: - Callbacks
    var buttonAction: (() -> Void)?
    var textChangedAction: ((String) -> Void)?
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupActions()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    private func setupUI() {
        contentView.backgroundColor = .secondarySystemBackground
        contentView.layer.cornerRadius = 12
        
        // 添加子视图
        contentView.addSubview(textView)
        contentView.addSubview(button)
        
        // 使用SnapKit布局
        textView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview().inset(12)
            make.height.equalTo(80)
        }
        
        button.snp.makeConstraints { make in
            make.top.equalTo(textView.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview().inset(12)
            make.height.equalTo(40)
            make.bottom.equalToSuperview().inset(12)
        }
    }
    
    private func setupActions() {
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        textView.delegate = self
    }
    
    // MARK: - Configuration
    func configure(text: String) {
        textView.text = text
    }
    
    // MARK: - Actions
    @objc private func buttonTapped() {
        buttonAction?()
    }
}

// MARK: - TextView Delegate
extension TextButtonCell: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        textChangedAction?(textView.text)
    }
}
