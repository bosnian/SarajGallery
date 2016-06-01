//
//  DetailViewController.swift
//  SarajGallery
//
//  Created by Ammar Hadzic on 5/31/16.
//  Copyright © 2016 Ammar. All rights reserved.
//

import UIKit
import Charts

class DetailViewController: UIViewController, ChartViewDelegate {
    
    
    @IBOutlet weak var lineChart: LineChartView!
    @IBOutlet weak var imageView: UIImageView!
    var id = 0
    var imageManager = ImageManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = imageManager.getImageAdIndex(id)?.img
        setupChart()
        imageManager.loadHighResImage(id, success: highResImageLoaded)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func highResImageLoaded(){
        imageView.image = imageManager.getImageAdIndex(id)?.img
    }
    
    
    func setupChart(){
        self.lineChart.delegate = self
        self.lineChart.descriptionText = "Tap node for details"
        self.lineChart.descriptionTextColor = UIColor.whiteColor()
        self.lineChart.gridBackgroundColor = UIColor.darkGrayColor()
        self.lineChart.noDataText = "No data provided"
        self.lineChart.leftAxis.axisMinValue = 0
        self.lineChart.rightAxis.enabled = false
    }
    
    func setChartData(img: UIImage) {
        let histData = img.SIHistogramCalculation()
        
        let emptyStrings = [String](count: 256, repeatedValue: "")
        var yRed = [ChartDataEntry]()
        var yBlue = [ChartDataEntry]()
        var yGreen = [ChartDataEntry]()
        for i in 0...255 {
            
            yRed.append(ChartDataEntry(value: Double(histData.red[i]), xIndex: i))
            yBlue.append(ChartDataEntry(value: Double(histData.blue[i]), xIndex: i))
            yGreen.append(ChartDataEntry(value: Double(histData.green[i]), xIndex: i))
        }
        
        let redSet: LineChartDataSet = LineChartDataSet(yVals: yRed, label: "Red")
        redSet.axisDependency = .Left // Line will correlate with left axis values
        redSet.setColor(UIColor.redColor().colorWithAlphaComponent(0.5)) // our line's opacity is 50%
        redSet.setCircleColor(UIColor.redColor()) // our circle will be dark red
        redSet.lineWidth = 2.0
        redSet.mode = .CubicBezier
        redSet.fillAlpha = 1
        redSet.fillColor = UIColor.redColor()
        redSet.drawCirclesEnabled = false
        
        
        let blueSet: LineChartDataSet = LineChartDataSet(yVals: yBlue, label: "Blue")
        blueSet.axisDependency = .Left // Line will correlate with left axis values
        blueSet.setColor(UIColor.blueColor().colorWithAlphaComponent(0.5)) // our line's opacity is 50%
        blueSet.setCircleColor(UIColor.blueColor()) // our circle will be dark red
        blueSet.lineWidth = 2.0
        blueSet.fillAlpha = 65 / 255.0
        blueSet.fillColor = UIColor.blueColor()
        blueSet.mode = .CubicBezier
        blueSet.drawCirclesEnabled = false
    
        
        let greenSet: LineChartDataSet = LineChartDataSet(yVals: yGreen, label: "Green")
        greenSet.axisDependency = .Left // Line will correlate with left axis values
        greenSet.setColor(UIColor.greenColor().colorWithAlphaComponent(0.5)) // our line's opacity is 50%
        greenSet.setCircleColor(UIColor.greenColor()) // our circle will be dark red
        greenSet.lineWidth = 2.0
        greenSet.fillAlpha = 65 / 255.0
        greenSet.fillColor = UIColor.greenColor()
        greenSet.mode = .CubicBezier
        greenSet.drawCirclesEnabled = false
        
        var dataSets : [LineChartDataSet] = [LineChartDataSet]()
        dataSets.append(redSet)
        dataSets.append(blueSet)
        dataSets.append(greenSet)
        
        let data: LineChartData = LineChartData(xVals: emptyStrings, dataSets: dataSets)
        data.setValueTextColor(UIColor.whiteColor())
        
        //5 - finally set our data
        self.lineChart.data = data
    }
    
    @IBAction func originalPressed(sender: AnyObject) {
        self.lineChart.hidden = true
        self.imageView.image = imageManager.getImageAdIndex(id)?.img
    }
    @IBAction func greyscalePressed(sender: AnyObject) {
        self.lineChart.hidden = true
        self.imageView.image = imageManager.getImageAdIndex(id)?.img?.GrayScaleFilter()
    }
    
    @IBAction func negativePressed(sender: AnyObject) {
        self.lineChart.hidden = true
        self.imageView.image = imageManager.getImageAdIndex(id)?.img?.NegativeFilter()
    }
    
    @IBAction func histogramPressed(sender: AnyObject) {
        self.lineChart.hidden = false
        setChartData(self.imageManager.getImageAdIndex(id)!.img!)
    }
}
