//
//  HabitTableViewCell.swift
//  Bad Habit Counter
//
//  Created by Ryan Elliott on 3/10/22.
//

import UIKit

class HabitTableViewCell: UITableViewCell {
    
    weak var viewController: ViewController!
    weak var habit: Habit!
    
    fileprivate weak var selectButtonView: UIView!
    weak var selectButton: UIButton!
    
    weak var habitLabel: UILabel!
    
    fileprivate weak var totalCountView: UIView!
    weak var totalCountLabel: UILabel!
    
    fileprivate weak var currCountView: UIView!
    weak var currCountLabel: UILabel!
    
    fileprivate weak var incrementButtonView: UIView!
    fileprivate weak var incrementButton: UIButton!
    
    let COUNT_WIDTH: CGFloat = 75
    let SIDE_PADDING: CGFloat = 25
    let BUTTON_VIEW_HEIGHT: CGFloat = 50
    let INCREMENT_BUTTON_SIDE: CGFloat = 50
    let SELECT_BUTTON_WIDTH: CGFloat = 75
    let SELECT_BUTTON_PADDING: CGFloat = 5
    let SMALL_PADDING: CGFloat = 5
    let BUTTON_BORDER_WIDTH: CGFloat = 2
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.isUserInteractionEnabled = true
            
        setUpSelectButtonView()
        setUpHabitLabel()
        setUpTotalCountView()
        setUpCurrCountView()
        setUpIncrementButtonView()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setUpSelectButtonView() {
        let parent: UIView = contentView
        let child: UIView = UIView()
        
        setUp(child, in: parent, top: parent.topAnchor, bottom: parent.bottomAnchor, leading: parent.leadingAnchor, trailing: nil)
        //child.centerYAnchor.constraint(equalTo: parent.centerYAnchor).isActive = true
        
        selectButtonView = child
        
        setUpSelectButton()
    }
    
    
    func setUpSelectButton() {
        let parent: UIView = selectButtonView
        let child: UIButton = UIButton()
        
        setUp(child, in: parent)
        child.widthAnchor.constraint(greaterThanOrEqualToConstant: SELECT_BUTTON_WIDTH).isActive = true
        
        //child.layer.cornerRadius = INCREMENT_BUTTON_SIDE / 2
        child.layer.borderColor = UIColor.white.cgColor
        child.layer.borderWidth = BUTTON_BORDER_WIDTH
        
        child.addTarget(self, action: #selector(selectButtonTapped), for: .touchUpInside)
        
        selectButton = child
    }
    
    func setUpHabitLabel() {
        let parent: UIView = contentView
        let child: UILabel = UILabel()
        
        setUp(child, in: parent, top: nil, bottom: nil, leading: selectButtonView.trailingAnchor, trailing: nil, spacing: [0, 0, SMALL_PADDING, 0])
        child.centerYAnchor.constraint(equalTo: parent.centerYAnchor).isActive = true
        
        habitLabel = child
    }

    func setUpTotalCountView() {
        let parent: UIView = contentView
        let child: UIView = UIView()
        
        setUp(child, in: parent, top: parent.topAnchor, bottom: parent.bottomAnchor, leading: nil, trailing: nil)
        child.widthAnchor.constraint(equalToConstant: COUNT_WIDTH).isActive = true
        
        child.backgroundColor = .purple
        
        totalCountView = child
        
        setUpTotalCountLabel()
    }
    
    func setUpTotalCountLabel() {
        let parent: UIView = totalCountView
        let child: UILabel = UILabel()
        
        setUp(child, in: parent, top: nil, bottom: nil, leading: nil, trailing: parent.trailingAnchor, spacing: [0, 0, 0, SMALL_PADDING])
        child.centerYAnchor.constraint(equalTo: parent.centerYAnchor).isActive = true
        
        totalCountLabel = child
    }
    
    func setUpCurrCountView() {
        let parent: UIView = contentView
        let child: UIView = UIView()
        
        setUp(child, in: parent, top: parent.topAnchor, bottom: parent.bottomAnchor, leading: totalCountView.trailingAnchor, trailing: nil)
        child.widthAnchor.constraint(equalToConstant: COUNT_WIDTH).isActive = true
        
        child.backgroundColor = .blue
        
        currCountView = child
        
        setUpCurrCountLabel()
    }
    
    func setUpCurrCountLabel() {
        let parent: UIView = currCountView
        let child: UILabel = UILabel()
        
        setUp(child, in: parent, top: nil, bottom: nil, leading: nil, trailing: parent.trailingAnchor, spacing: [0, 0, 0, SMALL_PADDING])
        child.centerYAnchor.constraint(equalTo: parent.centerYAnchor).isActive = true
        
        currCountLabel = child
    }
    
    func setUpIncrementButtonView() {
        let parent: UIView = contentView
        let child: UIView = UIView()
        
        setUp(child, in: parent, top: parent.topAnchor, bottom: parent.bottomAnchor, leading: currCountView.trailingAnchor, trailing: parent.trailingAnchor)
        //child.centerYAnchor.constraint(equalTo: parent.centerYAnchor).isActive = true
        child.widthAnchor.constraint(equalTo: child.heightAnchor).isActive = true
        
        incrementButtonView = child
        
        setUpIncrementButton()
    }
    
    
    func setUpIncrementButton() {
        let parent: UIView = incrementButtonView
        let child: UIButton = UIButton()
        
        setUp(child, in: parent)
        
        //child.layer.cornerRadius = INCREMENT_BUTTON_SIDE / 2
        child.layer.borderColor = UIColor.white.cgColor
        child.layer.borderWidth = BUTTON_BORDER_WIDTH
        //child.backgroundColor = .red
        child.setImage(UIImage(systemName: "plus"), for: .normal)
        
        child.addTarget(self, action: #selector(incrementButtonTapped), for: .touchUpInside)
        
        incrementButton = child
    }
    
    @objc func incrementButtonTapped() {
        habit.increment()
        viewController.scroll(to: Date())
        viewController.reloadAndWrite()
    }
    
    @objc func selectButtonTapped() {
        habit.toggle()
        viewController.refreshSelectionColor(for: viewController.selectedDate)
        viewController.reloadAndWrite()
    }

}
