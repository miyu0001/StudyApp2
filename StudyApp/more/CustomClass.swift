//
//  CustomClass.swift
//  StudyApp
//
//  Created by 佐藤未悠 on 2021/05/26.
//

import Foundation
import SwiftUI
struct CustomClass: View {
  var body: some View {
    Text("Hello")
  }
}
struct CustomClass_Previews: PreviewProvider {
  static var previews: some View {
    CustomClass()
  }
}
@IBDesignable class CustomButton: UIButton {
  // 角丸の半径(0で四角形)
  @IBInspectable var cornerRadius: CGFloat = 0.0
  // 枠
  @IBInspectable var borderColor: UIColor = UIColor.clear
  @IBInspectable var borderWidth: CGFloat = 0.0
  override func draw(_ rect: CGRect) {
    // 角丸
    self.layer.cornerRadius = cornerRadius
    self.clipsToBounds = (cornerRadius > 0)
    // 枠線
    self.layer.borderColor = borderColor.cgColor
    self.layer.borderWidth = borderWidth
    super.draw(rect)
  }
}
final class DateInputLabel: UILabel {
  var datePickerContainerView: UIView!
  override func awakeFromNib() {
    super.awakeFromNib()
    setupView()
  }
  override var canBecomeFirstResponder: Bool {
    return true
  }
  override var canResignFirstResponder: Bool {
    return true
  }
  override var inputView: UIView? {
    return datePickerContainerView
  }
  private func setupView() {
    isUserInteractionEnabled = true
    // 長押しでメニューを表示するのにロングプレスイベントを追加
    let longTap = UILongPressGestureRecognizer(target: self,
                          action: #selector(handleLongPressGesture(gesture:)))
    addGestureRecognizer(longTap)
  }
  @objc func handleLongPressGesture(gesture: UILongPressGestureRecognizer) {
    guard let text = text, !text.isEmpty else {
      return
    }
    let menuController = UIMenuController.shared
    if !menuController.isMenuVisible {
      let bounds = textRect(forBounds: self.bounds, limitedToNumberOfLines: 1)
      menuController.setTargetRect(bounds, in: self)
      menuController.setMenuVisible(true, animated: true)
    }
  }
}
@IBDesignable class PlaceHolderTextView: UITextView {
  // MARK: Stored Instance Properties
  @IBInspectable private var placeHolder: String = "" {
    willSet {
      self.placeHolderLabel.text = newValue
      self.placeHolderLabel.sizeToFit()
    }
  }
  private lazy var placeHolderLabel: UILabel = {
    let label = UILabel(frame: CGRect(x: 6.0, y: 6.0, width: 0.0, height: 0.0))
    label.lineBreakMode = .byWordWrapping
    label.numberOfLines = 0
    label.font = self.font
    label.textColor = UIColor(red: 0.0, green: 0.0, blue: 0.0980392, alpha: 0.22)
    label.backgroundColor = .clear
    self.addSubview(label)
    return label
  }()
  // MARK: Initializers
  deinit {
    NotificationCenter.default.removeObserver(self)
  }
  // MARK: View Life-Cycle Methods
  override func awakeFromNib() {
    super.awakeFromNib()
    changeVisiblePlaceHolder()
    NotificationCenter.default.addObserver(self, selector: #selector(textChanged),
                        name: UITextView.textDidChangeNotification, object: nil)
  }
  // MARK: Other Private Methods
  private func changeVisiblePlaceHolder() {
    self.placeHolderLabel.alpha = (self.placeHolder.isEmpty || !self.text.isEmpty) ? 0.0 : 1.0
  }
  @objc private func textChanged(notification: NSNotification?) {
    changeVisiblePlaceHolder()
  }
}
