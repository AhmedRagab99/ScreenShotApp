//
//  DrawingEngine.swift
//  ScreenShotApp
//
//  Created by Ahmed Ragab on 19/06/2024.
//

import Foundation
import SwiftUI

struct Line: Identifiable {
    
    var points: [CGPoint]
    var color: Color
    var lineWidth: CGFloat
    
    let id = UUID()
}


enum DrawingType {
    case line
    case rectangle
    case ellipse
    case circle
    case text
}

final class DrawingEngine:ObservableObject {
        
    @Published  var shapePath: Path?
    @Published  var selectedLineWidth: CGFloat = 2
    @Published  var selectedColor: Color = .red
    @Published var lines = [Line]()
    @Published var deletedLines = [Line]()
    
    
    @Published var text = "text to have write"
    @Published var textRect: CGRect?


    
    private var drawingType:DrawingType?
    private var startPoint: CGPoint?
    private var currentPoint: CGPoint?
    
    
    
    
    func setDrawingType(with type:DrawingType) {
        self.drawingType = type
    }
}

//MARK: - drawing lines and shapes methods
extension DrawingEngine {
    
    
    func draw(using context:GraphicsContext, and size:CGSize) {
        guard let drawingType = drawingType else {return}
        switch drawingType {
        case .line:
            drawLines(using: context)
        case .rectangle, .ellipse, .circle:
            drawShapes(using: context)
        case .text:
            drawText(using: context)
        }
    }
    
    func drawLines(using context:GraphicsContext) {
        guard lines.count > 0 else {return}
        for line in lines {
            
            let path = createPath(for: line.points)
            
            context.stroke(path, with: .color(line.color), style: StrokeStyle(lineWidth: line.lineWidth, lineCap: .round, lineJoin: .round))
            
        }
    }
    
    func drawShapes(using context:GraphicsContext) {
        guard let path = shapePath else {return}
        context.stroke(path, with: .color(selectedColor), lineWidth: selectedLineWidth)
    }
    
    func drawText(using context: GraphicsContext) {
        guard let textRect = textRect else {return}
        let text = Text(self.text)
            .foregroundColor(selectedColor)
            .font(.system(size: selectedLineWidth * 10)) // Adjust font size as needed
        context.draw(text, in: textRect)        
    }
}

//MARK: - update gestures state methods
extension DrawingEngine {
    
    func updateDragGestureOnChangedState(from value:DragGesture.Value) {
        guard let drawingType = drawingType else {return}
        switch drawingType {
        case .line:
            updateLinePathOnChangedState(using: value)
        case .rectangle,.circle,.ellipse:
            updateShapesPathOnChangedState(using: value)
        case .text:
            updateTextPathOnChangedState(using: value)
        }
    }
    
    func updateDragGestureOnEndedState(using value: DragGesture.Value) {
        guard let drawingType = drawingType else {return}
        switch drawingType {
        case .line:
            updateLinesOnEndedState(using: value)
        case .ellipse,.circle,.rectangle,.text:
            updateShapesOnEndedState()
        }
    }
    
    private func updateShapesOnEndedState() {
        self.startPoint = nil
        self.currentPoint = nil
        
    }
    
    private func updateLinesOnEndedState(using value:DragGesture.Value) {
        if let last = lines.last?.points, last.isEmpty {
            lines.removeLast()
        }
    }
    
    private func updateTextPathOnChangedState(using value:DragGesture.Value) {
        guard drawingType != nil else {return}
        
        if self.startPoint == nil {
            self.startPoint = value.location
        }
        self.currentPoint = value.location
        updateTextRect()
    }
    
    private func updateTextRect() {
        guard let startPoint = startPoint, let currentPoint = currentPoint else { return }
        textRect = CGRect(
            x: min(startPoint.x, currentPoint.x),
            y: min(startPoint.y, currentPoint.y),
            width: abs(currentPoint.x - startPoint.x),
            height: abs(currentPoint.y - startPoint.y)
        )
    }
    
    
    private func updateShapesPathOnChangedState(using value:DragGesture.Value) {
        guard let drawingType = drawingType else {return}
        
        if self.startPoint == nil {
            self.startPoint = value.location
        }
        self.currentPoint = value.location
        updateShapePath(from: drawingType)
    }
    
    private func updateShapePath(from type:DrawingType) {
        guard let startPoint = startPoint, let currentPoint = currentPoint, startPoint != currentPoint  else {
            shapePath = nil
            return
        }
        switch type {
            case .circle:
                shapePath = createCirclePath(center: startPoint, radius: 20)
            case .ellipse:
                shapePath = createEllipsePath(startPoint: startPoint, currentPoint: currentPoint)
            case .rectangle:
                shapePath = createRectanglePath(startPoint: startPoint, currentPoint: currentPoint)
            default:
                shapePath = nil
        }
    }
    
    private func updateLinePathOnChangedState(using value:DragGesture.Value) {
        let newPoint = value.location
        if value.translation.width + value.translation.height == 0 {
            //TODO: use selected color and linewidth
            lines.append(Line(points: [newPoint], color: selectedColor, lineWidth: selectedLineWidth))
        } else {
            let index = lines.count - 1
            
            lines[index].points.append(newPoint)
        }
    }
}

//MARK: - creating shapes and line methods
extension DrawingEngine {
    func createPath(for points: [CGPoint]) -> Path {
        var path = Path()
        if let firstPoint = points.first {
            path.move(to: firstPoint)
        }
        
        for index in 1..<points.count {
            let mid = calculateMidPoint(points[index - 1], points[index])
            path.addQuadCurve(to: mid, control: points[index - 1])
        }
        
        if let last = points.last {
            path.addLine(to: last)
        }
        
        
        return path
    }
    
    // Create a path for a rectangle
    func createRectanglePath(startPoint:CGPoint, currentPoint:CGPoint) -> Path {
        let rect = CGRect(
            x: min(startPoint.x, currentPoint.x),
            y: min(startPoint.y, currentPoint.y),
            width: abs(currentPoint.x - startPoint.x),
            height: abs(currentPoint.y - startPoint.y)
        )
        
        var path = Path()
        path.addRect(rect)
        
        return path
    }
    
    // Create a path for an ellipse
    func createEllipsePath(startPoint:CGPoint, currentPoint:CGPoint) -> Path {
        let rect = CGRect(
            x: min(startPoint.x, currentPoint.x),
            y: min(startPoint.y, currentPoint.y),
            width: abs(currentPoint.x - startPoint.x),
            height: abs(currentPoint.y - startPoint.y)
        )
        
        var path = Path()
        path.addEllipse(in: rect)
        return path
    }
    
    // Create a path for a circle
    func createCirclePath(center: CGPoint, radius: CGFloat) -> Path {
        var path = Path()
        let circleRect = CGRect(x: center.x - radius, y: center.y - radius, width: 2 * radius, height: 2 * radius)
        path.addEllipse(in: circleRect)
        return path
    }
  

    func calculateMidPoint(_ point1: CGPoint, _ point2: CGPoint) -> CGPoint {
        let newMidPoint = CGPoint(x: (point1.x + point2.x)/2, y: (point1.y + point2.y)/2)
        return newMidPoint
    }
}
