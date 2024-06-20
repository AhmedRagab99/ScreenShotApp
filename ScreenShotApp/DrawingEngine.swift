//
//  DrawingEngine.swift
//  ScreenShotApp
//
//  Created by Ahmed Ragab on 19/06/2024.
//

import Foundation
import SwiftUI
enum DrawingType {
    case line
    case rectangle
    case ellipse
    case circle
    case text
}

struct ShapeData: Identifiable {
    var id = UUID()
    var type: DrawingType
    var points: [CGPoint] = []
    var rect: CGRect? = nil // Used for rectangles, ellipses, and text bounding box
    var color: Color
    var lineWidth: CGFloat
    var text: String? = nil // Used for text
}



final class DrawingEngine:ObservableObject {
    
    @Published var shapes = [ShapeData]()
    @Published var selectedLineWidth: CGFloat = 2
    @Published var selectedColor: Color = .red
    @Published var shapesData = [ShapeData]()
    private var drawingType: DrawingType?
    private var startPoint: CGPoint?
    private var currentPoint: CGPoint?
    
    
    func setDrawingType(with type:DrawingType) {
        self.drawingType = type
    }
}

//MARK: - drawing lines and shapes methods
extension DrawingEngine {
    
    
    func draw(using context: GraphicsContext, and size: CGSize) {
        
        for shape in shapes {
            switch shape.type {
            case .line:
                drawLine(using: context, shape: shape)
            case .rectangle:
                if let path = drawRectangle(using: context, shape: shape) {
                    context.stroke(path, with: .color(shape.color),lineWidth: shape.lineWidth)
                }
            case .ellipse:
                if let path = drawEllipse(using: context, shape: shape) {
                    context.stroke(path, with: .color(shape.color),lineWidth: shape.lineWidth)
                }
            case .circle:
                if let path = drawCircle(using: context, shape: shape) {
                    context.stroke(path, with: .color(shape.color),lineWidth: shape.lineWidth)
                }
            case .text:
                if let path = drawText(using: context, shape: shape) {
                    context.stroke(path, with: .color(shape.color),lineWidth: shape.lineWidth)
                }
            }
        }
    }
    
    
    private func drawLine(using context: GraphicsContext, shape: ShapeData) {
        guard shape.points.count > 0 else { return }
        let path = createPath(for: shape.points)
        context.stroke(path, with: .color(shape.color), style: StrokeStyle(lineWidth: shape.lineWidth, lineCap: .round, lineJoin: .round))
    }
    
    private func drawRectangle(using context: GraphicsContext, shape: ShapeData) -> Path? {
        guard let rect = shape.rect else { return nil}
        let path = Path(rect)
        return path
    }
    
    private func drawEllipse(using context: GraphicsContext, shape: ShapeData) -> Path? {
        guard let rect = shape.rect else { return nil }
        let path = Path(ellipseIn: rect)
        return path
        
    }
    
    private func drawCircle(using context: GraphicsContext, shape: ShapeData) -> Path? {
        guard let center = shape.rect?.origin, let radius = shape.rect?.width else { return nil}
        let path = createCirclePath(center: center, radius: radius)
        return path
    }
    
    private func drawText(using context: GraphicsContext, shape: ShapeData) -> Path? {
        guard let rect = shape.rect, let text = shape.text else { return nil}
        let attributedText = AttributedString(text, attributes: .init([.font: Font.system(size: shape.lineWidth * 10), .foregroundColor: shape.color]))
        let path = Path(rect)
        return path
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
            updateLineOnEndedState(using: value)
        case .ellipse,.circle,.rectangle,.text:
            updateShapesOnEndedState(using: value)
        }
    }
    
    private func updateShapesOnEndedState(using value:DragGesture.Value) {
        self.startPoint = nil
        self.currentPoint = nil
        
    }
    
    private func updateLineOnEndedState(using value: DragGesture.Value) {
        guard let drawingType = drawingType else {return}
        let newPoint = value.location
        if value.translation.width + value.translation.height == 0 {
            shapes.append(ShapeData(type: drawingType, points: [newPoint], color: selectedColor, lineWidth: selectedLineWidth))
        } else {
            let index = shapes.count - 1
            shapes[index].points.append(newPoint)
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
        let rect = CGRect(x: min(startPoint.x, currentPoint.x),
                          y: min(startPoint.y, currentPoint.y),
                          width: abs(currentPoint.x - startPoint.x),
                          height: abs(currentPoint.y - startPoint.y))
        shapes.append(ShapeData(type: .text, rect: rect, color: selectedColor, lineWidth: selectedLineWidth, text: "Sample Text"))
    }
    
    
    private func updateShapesPathOnChangedState(using value:DragGesture.Value) {
        guard let drawingType = drawingType else { return }
        
        if startPoint == nil {
            startPoint = value.startLocation
            addShape(type: drawingType, at: value.startLocation)
        }
        
        currentPoint = value.location
        updateShapePath()
    }
    private func addShape(type: DrawingType, at point: CGPoint) {
        let shape = ShapeData(type: type, color: selectedColor, lineWidth: selectedLineWidth)
        shapes.append(shape)
    }
    
    private func updateShapePath() {
        guard let startPoint = startPoint, let currentPoint = currentPoint else { return }
        
        let rect = CGRect(x: min(startPoint.x, currentPoint.x),
                          y: min(startPoint.y, currentPoint.y),
                          width: abs(currentPoint.x - startPoint.x),
                          height: abs(currentPoint.y - startPoint.y))
        
        if drawingType == .circle {
            let radius = startPoint.distance(to: currentPoint)
            shapes[shapes.count - 1].rect = CGRect(x: startPoint.x - radius, y: startPoint.y - radius, width: 2 * radius, height: 2 * radius)
        } else {
            shapes[shapes.count - 1].rect = rect
        }
    }
}

//MARK: - creating shapes and line methods
extension DrawingEngine {
    private func createPath(for points: [CGPoint]) -> Path {
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
    
    private func createCirclePath(center: CGPoint, radius: CGFloat) -> Path {
        let circleRect = CGRect(x: center.x - radius, y: center.y - radius, width: 2 * radius, height: 2 * radius)
        return Path(ellipseIn: circleRect)
    }
    
    private func calculateMidPoint(_ point1: CGPoint, _ point2: CGPoint) -> CGPoint {
        return CGPoint(x: (point1.x + point2.x) / 2, y: (point1.y + point2.y) / 2)
    }
    
    private func updateLinePathOnChangedState(using value:DragGesture.Value) {
        guard let drawingType =  drawingType else {return}
        let newPoint = value.location
        if value.translation.width + value.translation.height == 0 {
            //TODO: use selected color and linewidth
            shapes.append(ShapeData(type: drawingType,points: [newPoint], color: selectedColor, lineWidth: selectedLineWidth))
        } else {
            let index = shapes.count - 1
            shapes[index].points.append(newPoint)
        }
    }
}

extension CGPoint {
    func distance(to point: CGPoint) -> CGFloat {
        return sqrt(pow(point.x - self.x, 2) + pow(point.y - self.y, 2))
    }
}
