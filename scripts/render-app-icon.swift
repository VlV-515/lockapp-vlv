#!/usr/bin/env swift
import AppKit

let rootURL = URL(fileURLWithPath: FileManager.default.currentDirectoryPath)
let resourcesURL = rootURL.appendingPathComponent("Resources", isDirectory: true)
try FileManager.default.createDirectory(at: resourcesURL, withIntermediateDirectories: true)

let canvasSize = 1024
let canvasRect = NSRect(x: 0, y: 0, width: canvasSize, height: canvasSize)
let image = NSImage(size: canvasRect.size)

image.lockFocus()
guard let context = NSGraphicsContext.current?.cgContext else {
    fatalError("Unable to create drawing context")
}

context.setAllowsAntialiasing(true)
context.setShouldAntialias(true)
NSColor.clear.setFill()
canvasRect.fill()

let tileRect = NSRect(x: 120, y: 120, width: 784, height: 784)
let tilePath = NSBezierPath(roundedRect: tileRect, xRadius: 190, yRadius: 190)
let tileShadow = NSShadow()
tileShadow.shadowOffset = NSSize(width: 0, height: -18)
tileShadow.shadowBlurRadius = 34
tileShadow.shadowColor = NSColor.black.withAlphaComponent(0.18)
tileShadow.set()
NSGradient(
    colors: [
        NSColor(calibratedWhite: 1.0, alpha: 1.0),
        NSColor(calibratedRed: 0.94, green: 0.95, blue: 0.96, alpha: 1.0)
    ]
)?.draw(in: tilePath, angle: 90)

NSGraphicsContext.saveGraphicsState()
tilePath.addClip()
NSColor(calibratedWhite: 1.0, alpha: 0.46).setStroke()
tilePath.lineWidth = 4
tilePath.stroke()
NSGraphicsContext.restoreGraphicsState()

let lockShadow = NSShadow()
lockShadow.shadowOffset = NSSize(width: 0, height: -20)
lockShadow.shadowBlurRadius = 32
lockShadow.shadowColor = NSColor(calibratedRed: 0.99, green: 0.13, blue: 0.22, alpha: 0.35)
lockShadow.set()

let shackleOuter = NSBezierPath()
shackleOuter.appendRoundedRect(NSRect(x: 368, y: 560, width: 288, height: 294), xRadius: 136, yRadius: 136)
shackleOuter.lineWidth = 80
NSColor(calibratedRed: 0.96, green: 0.11, blue: 0.20, alpha: 1.0).setStroke()
shackleOuter.stroke()

let shackleHighlight = NSBezierPath()
shackleHighlight.appendRoundedRect(NSRect(x: 393, y: 591, width: 238, height: 226), xRadius: 112, yRadius: 112)
shackleHighlight.lineWidth = 18
NSColor.white.withAlphaComponent(0.33).setStroke()
shackleHighlight.stroke()

let bodyRect = NSRect(x: 290, y: 338, width: 444, height: 286)
let bodyPath = NSBezierPath(roundedRect: bodyRect, xRadius: 92, yRadius: 92)
NSGradient(
    colors: [
        NSColor(calibratedRed: 1.0, green: 0.34, blue: 0.39, alpha: 1.0),
        NSColor(calibratedRed: 0.94, green: 0.09, blue: 0.17, alpha: 1.0)
    ]
)?.draw(in: bodyPath, angle: 90)

NSGraphicsContext.current?.cgContext.setShadow(offset: .zero, blur: 0)
NSColor.white.withAlphaComponent(0.18).setStroke()
bodyPath.lineWidth = 5
bodyPath.stroke()

let dotY: CGFloat = 484
for x in [416, 512, 608] as [CGFloat] {
    let dotRect = NSRect(x: x - 24, y: dotY - 24, width: 48, height: 48)
    let dotPath = NSBezierPath(ovalIn: dotRect)
    NSColor.white.withAlphaComponent(0.70).setFill()
    dotPath.fill()
    NSColor(calibratedRed: 0.70, green: 0.05, blue: 0.12, alpha: 0.14).setStroke()
    dotPath.lineWidth = 3
    dotPath.stroke()
}

let chevron = NSBezierPath()
chevron.move(to: NSPoint(x: 442, y: 406))
chevron.line(to: NSPoint(x: 512, y: 370))
chevron.line(to: NSPoint(x: 582, y: 406))
chevron.lineWidth = 18
chevron.lineCapStyle = .round
chevron.lineJoinStyle = .round
NSColor.white.withAlphaComponent(0.28).setStroke()
chevron.stroke()

image.unlockFocus()

guard let tiffData = image.tiffRepresentation,
      let bitmap = NSBitmapImageRep(data: tiffData),
      let pngData = bitmap.representation(using: .png, properties: [:]) else {
    fatalError("Unable to encode app icon PNG")
}

let pngURL = resourcesURL.appendingPathComponent("AppIcon.png")
try pngData.write(to: pngURL)
print("Rendered \(pngURL.path)")
