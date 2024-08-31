//
//  BarChartViewContainer.swift
//  SampleCoreData2
//
//  Created by Harshal Ogale
//


import SwiftUI
import Charts
import CashTrackerShared

struct ExpenseBarChart: View {
    @Binding var expenses: [Expense]
    @State private var month = Date().firstDateOfMonth
    
    var body: some View {
        VStack {
            ExpenseBarChartMonthPicker(month: $month)
            BarChartViewContainer(expenses, forMonth: $month)
            Spacer()
        }
    }
}




struct ExpenseBarChartMonthPicker: View {
    @Binding var month: Date
    
    var body: some View {
        HStack {
            Spacer()
            Button(action: {
                self.month = Calendar.current.date(byAdding: .month, value: -1, to: self.month, wrappingComponents: false)!
            }) {
                Image(systemName: "arrow.left.square.fill")
                    .imageScale(.large)
            }
            
            Text(DateFormatter.expMonthYearOnlyFormatter.string(from: month.firstDateOfMonth))
            
            Button(action: {
                self.month = Calendar.current.date(byAdding: .month, value: 1, to: self.month, wrappingComponents: false)!
            }) {
                Image(systemName: "arrow.right.square.fill")
                    .imageScale(.large)
            }
            Spacer()
        }
    }
}




struct BarChartViewContainer: UIViewRepresentable {
    private var expenses: [Expense]
    private var expByDate: Dictionary<Date, [Expense]>
    private var totalByDate: Dictionary<Date, Double>
    
    private var monthDate: Binding<Date>
    
    init(_ expenses:[Expense],
         forMonth month: Binding<Date>) {
        self.expenses = expenses
        
        self.monthDate = month
        
        totalByDate = [:]
        
        expByDate = Dictionary(grouping: expenses, by: { Calendar.current.startOfDay(for: $0.datetime!) })
            .filter { $0.0.firstDateOfMonth == month.wrappedValue }
        
        totalByDate = expByDate.mapValues( { $0.map( { $0.amount } ).reduce(0, +) })
    }
    
    func makeCoordinator() -> BarChartViewContainer.Coordinator {
        Coordinator(self)
    }
    
    func setChartData(chartView: BarChartView) {
        let firstOfMonth = monthDate.wrappedValue.firstDateOfMonth.dayComponent
        let lastOfMonth = monthDate.wrappedValue.lastDateOfMonth.dayComponent
        
        let yVals = (firstOfMonth...lastOfMonth).map { (i) -> BarChartDataEntry in
            return BarChartDataEntry(x: Double(i), y: 0.0)
        }
        
        for entry in totalByDate {
            yVals[entry.key.dayComponent - 1].y = entry.value
            yVals[entry.key.dayComponent - 1].data = entry.key
        }
        
        var set1: BarChartDataSet! = nil
        if let set = chartView.data?.dataSets.first as? BarChartDataSet {
            set1 = set
            set1.replaceEntries(yVals)
            chartView.data?.notifyDataChanged()
            chartView.notifyDataSetChanged()
        } else {
            set1 = BarChartDataSet(entries: yVals, label: "Datewise Expense")
            set1.colors = ChartColorTemplates.vordiplom()
            set1.drawValuesEnabled = false
            
            let data = BarChartData(dataSet: set1)
            data.setValueFont(UIFont(name: "HelveticaNeue-Light", size: 10)!)
            data.barWidth = 0.9
            chartView.data = data
        }
        
        //chartView.setNeedsDisplay()
    }
    
    func makeUIView(context: UIViewRepresentableContext<BarChartViewContainer>) -> BarChartView {
        
        let chartView = BarChartView(frame: .zero)
        
        chartView.chartDescription.enabled = false
        chartView.dragEnabled = true
        chartView.setScaleEnabled(true)
        chartView.pinchZoomEnabled = false
        chartView.rightAxis.enabled = false
        chartView.delegate = context.coordinator
        chartView.drawBarShadowEnabled = false
        chartView.drawValueAboveBarEnabled = false
        chartView.maxVisibleCount = 60
        chartView.animate(yAxisDuration: 1)
        
        let xAxis = chartView.xAxis
        xAxis.labelPosition = .bottom
        xAxis.labelFont = .systemFont(ofSize: 10)
        xAxis.granularity = 1
        xAxis.labelCount = 7
        //xAxis.valueFormatter = DayAxisValueFormatter(chart: chartView)
        
        let leftAxisFormatter = NumberFormatter()
        leftAxisFormatter.minimumFractionDigits = 0
        leftAxisFormatter.maximumFractionDigits = 1
        leftAxisFormatter.negativeSuffix = " " + (Locale.current.currencySymbol ?? "$")
        leftAxisFormatter.positiveSuffix = leftAxisFormatter.negativeSuffix
        
        let leftAxis = chartView.leftAxis
        leftAxis.labelFont = .systemFont(ofSize: 10)
        leftAxis.labelCount = 8
        leftAxis.valueFormatter = DefaultAxisValueFormatter(formatter: leftAxisFormatter)
        leftAxis.labelPosition = .outsideChart
        leftAxis.spaceTop = 0.15
        leftAxis.axisMinimum = 0 // FIXME: HUH?? this replaces startAtZero = YES
        
        let rightAxis = chartView.rightAxis
        rightAxis.enabled = true
        rightAxis.labelFont = .systemFont(ofSize: 10)
        rightAxis.labelCount = 8
        rightAxis.valueFormatter = leftAxis.valueFormatter
        rightAxis.spaceTop = 0.15
        rightAxis.axisMinimum = 0
        
        let l = chartView.legend
        l.horizontalAlignment = .left
        l.verticalAlignment = .bottom
        l.orientation = .horizontal
        l.drawInside = false
        l.form = .circle
        l.formSize = 9
        l.font = UIFont(name: "HelveticaNeue-Light", size: 11)!
        l.xEntrySpace = 4
        
        let marker = XYMarkerView(color: UIColor(white: 180/250, alpha: 1),
                                  font: .systemFont(ofSize: 12),
                                  textColor: .white,
                                  insets: UIEdgeInsets(top: 8, left: 8, bottom: 20, right: 8),
                                  xAxisValueFormatter: chartView.xAxis.valueFormatter!)
        marker.chartView = chartView
        marker.minimumSize = CGSize(width: 80, height: 40)
        chartView.marker = marker
        
        return chartView
    }
    
    func updateUIView(_ uiView: BarChartView, context: UIViewRepresentableContext<BarChartViewContainer>) {
        setChartData(chartView: uiView)
        
        uiView.animate(yAxisDuration: 1)
        uiView.lastHighlighted = nil
        uiView.highlightValue(nil, callDelegate: false)
    }
    
    class Coordinator: NSObject, ChartViewDelegate {
        var parent: BarChartViewContainer
        
        init(_ barChartContainer: BarChartViewContainer) {
            self.parent = barChartContainer
        }
    }
}
