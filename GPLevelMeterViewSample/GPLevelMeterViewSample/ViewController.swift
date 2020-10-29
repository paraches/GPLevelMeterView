//
//  ViewController.swift
//  GPLevelMeterViewSample
//
//  Created by shinichi teshirogi on 2020/10/21.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var portraitLeftFill: GPLevelMeterView!
    @IBOutlet weak var portraitLeftSlice: GPLevelMeterView!
    @IBOutlet weak var portraitNoneSlice: GPLevelMeterView!
    @IBOutlet weak var portraitRightFill: GPLevelMeterView!
    @IBOutlet weak var portraitNoneSliceCenter: GPLevelMeterView!
    @IBOutlet weak var landscapeTopFill: GPLevelMeterView!
    @IBOutlet weak var landscapeTopSlice: GPLevelMeterView!
    @IBOutlet weak var landscapeNoneSlice: GPLevelMeterView!
    @IBOutlet weak var landscapeBottomFill: GPLevelMeterView!
    @IBOutlet weak var landscapeTopFillCenter: GPLevelMeterView!
    @IBOutlet weak var landscapeCustomColors: GPLevelMeterView!
    @IBOutlet weak var sliderValueLabel: UILabel!
    
    var levelMeterByCode: GPLevelMeterView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupCustomLevelMeter()
        createLevelMeterByCode()
    }

    @IBAction func sliderValueChanged(_ sender: Any) {
        if let slider = sender as? UISlider {
            portraitLeftFill.value = CGFloat(slider.value)
            portraitLeftSlice.value = CGFloat(slider.value)
            portraitNoneSlice.value = CGFloat(slider.value)
            portraitRightFill.value = CGFloat(slider.value)
            portraitNoneSliceCenter.value = CGFloat(slider.value)
            landscapeTopFill.value = CGFloat(slider.value)
            landscapeTopSlice.value = CGFloat(slider.value)
            landscapeNoneSlice.value = CGFloat(slider.value)
            landscapeBottomFill.value = CGFloat(slider.value)
            landscapeTopFillCenter.value = CGFloat(slider.value)
            landscapeCustomColors.value = CGFloat(slider.value)
            
            levelMeterByCode?.value = CGFloat(slider.value)
            
            sliderValueLabel?.text = String(format: "%.2F", slider.value)
        }
    }
    
    private func setupCustomLevelMeter() {
        let customColors: [UIColor] = [.red, .orange, .magenta, .blue]
        landscapeCustomColors.meterColor = customColors
        landscapeCustomColors.scaleResolution = 8
    }
    
    private func createLevelMeterByCode() {
        let codeLevelMeter = GPLevelMeterView(frame: CGRect(x: 16, y: 366, width: 339, height: 32),
                                     orientation: .landscape,
                                     scalePosition: .top,
                                     zeroCenter: false)
        self.view.addSubview(codeLevelMeter)
        self.levelMeterByCode = codeLevelMeter
    }
}

