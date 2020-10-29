//
//  GPLevelMeterView.swift
//  GPLevelMeterViewSample
//
//  Created by shinichi teshirogi on 2020/10/10.
//

import Foundation
import UIKit

@IBDesignable final class GPLevelMeterView: UIView {
    enum Orientation: Int {
        case landscape = 0, portrait
    }
    
    enum MeterType: Int {
        case fill = 0, slice
    }
    
    enum ScalePosition: Int {
        case none = 0, left, top, right, bottom
    }
    
    var orientation: Orientation = .landscape

    @IBInspectable var zeroCenter: Bool = false
    var meterType: MeterType = .fill
    var meterColor: [UIColor] = [.red, .red, .red,
                               .yellow, .yellow, .yellow, .yellow,
                               .green, .green, .green]
    var meterResolution: CGFloat {
        return CGFloat(meterColor.count)
    }

    var scalePosition: ScalePosition = .none
    @IBInspectable var scaleResolution: CGFloat = 10
    @IBInspectable var scaleHeight: CGFloat = 8
    var barHeight: CGFloat {
        return (isLandscape ? bounds.height : bounds.width) - scaleHeight
    }
        
    var isLandscape: Bool {
        return orientation == .landscape
    }
    
    var value: CGFloat = 0.0 {
        didSet {
            if self.value > 1 {
                self.value = 1
            }
            else if self.value < -1 {
                self.value = -1
            }
            update()
        }
    }

    var scaleRect: CGRect {
        return scalePosition == .none ?
            CGRect.zero :
            bounds.inset(by: UIEdgeInsets(top: scalePosition == .bottom ? barHeight : 0,
                                          left: scalePosition == .right ? barHeight : 0,
                                          bottom: scalePosition == .top ? barHeight : 0,
                                          right: scalePosition == .left ? barHeight : 0))
    }
    
    var barRect: CGRect {
        return bounds.inset(by: UIEdgeInsets(
                                    top: isLandscape && scalePosition == .top ? scaleHeight : 0,
                                    left: !isLandscape && scalePosition == .left ? scaleHeight : 0,
                                    bottom: isLandscape && scalePosition == .bottom ? scaleHeight : 0,
                                    right: !isLandscape && scalePosition == .right ? scaleHeight : 0))
    }

    var sliceSize: CGFloat {
        let fullSize = (isLandscape ? barRect.width : barRect.height)
        return (zeroCenter ? fullSize / 2 : fullSize) / meterResolution
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    init(frame: CGRect,
         orientation: Orientation = .landscape,
         scalePosition: ScalePosition = .top,
         zeroCenter: Bool = false) {
        super.init(frame: frame)
        self.orientation = orientation
        self.scalePosition = scalePosition
        self.zeroCenter = zeroCenter
        
        self.backgroundColor = UIColor.systemBackground
    }
    
    override func draw(_ rect: CGRect) {
        if scalePosition != .none {
            drawScale()
        }
        drawBar()
    }
    
    private func drawScale() {
        self.tintColor.setStroke()
        let bp = UIBezierPath()
        bp.lineWidth = 1.0
        let stepSize = (isLandscape ? scaleRect.width : scaleRect.height) / scaleResolution
        for i in 0...Int(scaleResolution) {
            let x = scaleRect.origin.x + (isLandscape ? CGFloat(i) * stepSize : 0)
            let y = scaleRect.origin.y + (isLandscape ? 0 : CGFloat(i) * stepSize)
            let point = CGPoint(x: x, y: y)
            bp.move(to: point)
            let lineTo = CGPoint(x: x + (isLandscape ? 0 : scaleHeight),
                                 y: y + (isLandscape ? scaleHeight : 0))
            bp.addLine(to: lineTo)
        }
        bp.close()
        bp.stroke()
    }
    
    private func drawBar() {
        clearBar()
        switch meterType {
        case .fill:
            drawFixBar()
        case .slice:
            drawSliceBar()
        }
    }
    
    private func clearBar() {
        self.backgroundColor?.setFill()
        UIBezierPath(rect: barRect).fill()
    }

    private func drawFixBar() {
        calcDrawColor(at: value).setFill()
        let drawRect = zeroCenter ? calcZeroCenterRect() : barRect
        let framePath = UIBezierPath(rect: calcDrawRect(drawRect))
        framePath.fill()
    }
    
    private func calcDrawColor(at value: CGFloat) -> UIColor {
        let size = (meterResolution - 1) * abs(value)
        return meterColor[Int(size)]
    }
    
    private func calcZeroCenterRect() -> CGRect {
        let size = (isLandscape ? barRect.width : barRect.height) / 2
        let zeroCenterRect = barRect.inset(by: UIEdgeInsets(
                                            top: value < 0 && !isLandscape ? size : 0,
                                            left: value > 0 && isLandscape ? size : 0,
                                            bottom: value > 0 && !isLandscape ? size : 0,
                                            right: value < 0 && isLandscape ? size : 0))
        return zeroCenterRect
    }
    
    private func calcDrawRect(_ barRect: CGRect) -> CGRect {
        let insetValue = isLandscape ? barRect.width * (1 - abs(value)) : barRect.height * (1 - abs(value))
        return value == 0 ?
            CGRect.zero :
            barRect.inset(by: UIEdgeInsets(
                            top: !isLandscape && value > 0 ? insetValue : 0,
                            left: isLandscape && value < 0 ? insetValue : 0,
                            bottom: !isLandscape && value < 0 ? insetValue : 0,
                            right: isLandscape && value > 0 ? insetValue : 0))
    }

    private func drawSliceBar() {
        let rect = zeroCenter ? calcZeroCenterRect() : barRect
        drawSliceBar(at: rect)
    }
    
    private func drawSliceBar(at barRect: CGRect) {
        for i in 0..<Int(meterResolution) {
            if i >= Int(abs(value) * meterResolution) {
                break
            }
            calcDrawColor(at: CGFloat(i+1) / meterResolution).setFill()
            let (x, y) = calcSlicedBarOrigin(at: i, sliceSize: sliceSize, rect: barRect)
            let origin = CGPoint(x: x, y: y)
            let size = CGSize(width: (isLandscape ? sliceSize : barRect.width), height: (isLandscape ? barRect.height : sliceSize))
            let sliceBarRect = CGRect(origin: origin, size: size)
            let framePath = UIBezierPath(rect: sliceBarRect.insetBy(dx: 1.0, dy: 1.0))
            framePath.fill()
        }
    }
    
    private func calcSlicedBarOrigin(at i: Int, sliceSize: CGFloat, rect: CGRect) -> (CGFloat, CGFloat) {
        if value > 0 {
            let x = isLandscape ? rect.origin.x + CGFloat(i) * sliceSize : rect.origin.x
            let y = isLandscape ? rect.origin.y : (rect.origin.y + rect.height - (CGFloat(i) + 1) * sliceSize)
            return (x, y)
        }
        else {
            let x = isLandscape ? rect.origin.x + rect.width - ((CGFloat(i) + 1) * sliceSize) : barRect.origin.x
            let y = isLandscape ? rect.origin.y : rect.origin.y + CGFloat(i) * sliceSize
            return (x, y)
        }
    }
    
    private func update() {
        setNeedsDisplay()
    }
}

extension GPLevelMeterView {
    @available(*, unavailable, message: "This property is reserved for IB. Use 'meterType' instead.", renamed: "meterType")
    @IBInspectable var meterTypeValue: Int {
        get {
            return self.meterType.rawValue
        }
        set(newValue) {
            self.meterType = MeterType(rawValue: newValue) ?? .fill
        }
    }

    @available(*, unavailable, message: "This property is reserved for IB. Use 'orientation' instead.", renamed: "orientation")
    @IBInspectable var orientationValue: Int {
        get {
            return self.orientation.rawValue
        }
        set(newValue) {
            self.orientation = Orientation(rawValue: newValue) ?? .landscape
        }
    }
    
    @available(*, unavailable, message: "This property is reserved for IB. Use 'scalePosition' instead.", renamed: "scalePosition")
    @IBInspectable var scalePositionValue: Int {
        get {
            return self.scalePosition.rawValue
        }
        set(newValue) {
            self.scalePosition = ScalePosition(rawValue: newValue) ?? .none
        }
    }
}
