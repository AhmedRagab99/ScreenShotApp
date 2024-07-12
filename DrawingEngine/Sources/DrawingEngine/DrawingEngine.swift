// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation
import SwiftUI


public enum DrawingType {
    case line
    case rectangle
    case ellipse
    case circle
    case arrow
}

public struct ShapeData: Identifiable {
    public var id = UUID()
    public var type: DrawingType
    public var points: [CGPoint] = []
    public var rect: CGRect? = nil // Used for rectangles, ellipses, and text bounding box
    public var color: Color
    public var lineWidth: CGFloat
    public var isSelected: Bool = false // Add this property
}



public final class DrawingEngine:ObservableObject {
    
    @Published public var shapes = [ShapeData]()
    
    @Published public var selectedLineWidth: CGFloat = 2
    @Published public var selectedColor: Color = .red
    @Published var selectedShapeID: UUID? = nil
     
    private var deletedShapes = [ShapeData]()
    private var drawingType: DrawingType?
    private var startPoint: CGPoint?
    private var currentPoint: CGPoint?
    private var canvasSize:CGSize = .zero
    
    public init() {}
    
    public func setDrawingType(with type:DrawingType) {
        self.drawingType = type
    }
    
    public func setCanvasSize(with size:CGSize) {
        self.canvasSize = size
    }
    public func getCanvasSize() -> CGSize {
        return canvasSize
    }
}

//MARK: - undo and redo methods
extension DrawingEngine {
    public func redoDrawing() {
        let last = self.deletedShapes.removeLast()
        shapes.append(last)
    }
    public func redoValidation() -> Bool {
        return deletedShapes.count == 0
    }
    
    public func undoDrawing() {
        let last = shapes.removeLast()
        deletedShapes.append(last)
    }
    public func undoValidation() -> Bool {
        return shapes.count == 0
    }
    
    public func removeAll() {
        shapes.removeAll()
        deletedShapes.removeAll()
    }
}

//MARK: - drawing lines and shapes methods
extension DrawingEngine {
    
    
    public func draw(using context: GraphicsContext, and size: CGSize) {
        
        for shape in shapes {
            switch shape.type {
            case .line:
                drawLine(using: context, shape: shape)
            case .arrow:
                drawArrow(using: context, shape: shape)
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
            }
        }
    }
    
    
    private func drawLine(using context: GraphicsContext, shape: ShapeData) {
        guard shape.points.count > 0 else { return }
        let path = createPath(for: shape.points)
        context.stroke(path, with: .color(shape.color), style: StrokeStyle(lineWidth: shape.lineWidth, lineCap: .round, lineJoin: .round))
    }
    private func drawArrow(using context:GraphicsContext, shape:ShapeData) {
        guard shape.points.count > 0 else { return }
        let path = createArrowPath(for: shape.points)
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
    
}


//MARK: - update gestures state methods
extension DrawingEngine {
    
    public func updateDragGestureOnChangedState(from value:DragGesture.Value) {
        guard let drawingType = drawingType else {return}
        switch drawingType {
        case .line,.arrow:
            updateLinePathOnChangedState(using: value)
        case .rectangle,.circle,.ellipse:
            updateShapesPathOnChangedState(using: value)
        }
    }
    
   public  func updateDragGestureOnEndedState(using value: DragGesture.Value) {
        guard let drawingType = drawingType else {return}
        switch drawingType {
        case .line,.arrow:
            updateLineOnEndedState(using: value)
        case .ellipse,.circle,.rectangle:
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
    
    private func createArrowPath(for points: [CGPoint]) -> Path {
        var path = Path()
        
        guard let firstPoint = points.first, let lastPoint = points.last else {
            return path
        }
        
        // Calculate the arrowhead size and direction
        let arrowSize: CGFloat = 10  // Adjust arrowhead size as needed
        let direction = CGVector(dx: lastPoint.x - firstPoint.x, dy: lastPoint.y - firstPoint.y)
        let length = sqrt(direction.dx * direction.dx + direction.dy * direction.dy)
        
        // Ensure the line has sufficient length to draw an arrow
        guard length > arrowSize else {
            // If the line is too short to draw an arrow, draw a straight line
            path.move(to: firstPoint)
            path.addLine(to: lastPoint)
            return path
        }
        
        // Normalize direction vector
        let normalizedDirection = CGVector(dx: direction.dx / length, dy: direction.dy / length)
        
        // Calculate points for the arrowhead
        let arrowheadPoints = [
            CGPoint(x: lastPoint.x - normalizedDirection.dx * arrowSize + normalizedDirection.dy * arrowSize,
                    y: lastPoint.y - normalizedDirection.dy * arrowSize - normalizedDirection.dx * arrowSize),
            lastPoint,
            CGPoint(x: lastPoint.x - normalizedDirection.dx * arrowSize - normalizedDirection.dy * arrowSize,
                    y: lastPoint.y - normalizedDirection.dy * arrowSize + normalizedDirection.dx * arrowSize)
        ]
        
        // Create path for arrow
        path.move(to: firstPoint)
        for point in points.dropFirst() {
            path.addLine(to: point)
        }
        
        // Add arrowhead to the path
        path.addLines(arrowheadPoints)
        
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
