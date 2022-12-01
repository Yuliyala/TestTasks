import Foundation

struct Point {
    let x: Int
    let y: Int

    static func + (lhs: Point, rhs: Point) -> Point {
        return Point(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
    }
}

struct Line {
    let start: Point
    let end: Point
    
    private func doesContainPoint(point: Point) -> Bool {
        if ((point.x - start.x) * (end.y - start.y) == (point.y - start.y) * (end.x - start.x)) {
            return true
        }
        return false
    }
  
    func doesContainLine(line: Line) -> Bool {
        return doesContainPoint(point: line.start) && doesContainPoint(point: line.end)
    }

    var lineSize: Double {
        sqrt(pow((Double(end.x - start.x)), 2) + pow((Double(end.y - start.y)), 2))
    }
}

struct Figure {
    let position: Point
    let figurePoints: (a: Point, b: Point, c: Point, d: Point)

    func getLines() -> [Line] {
        return [
            Line(start: figurePoints.a + position, end: figurePoints.b + position),
            Line(start: figurePoints.b + position, end: figurePoints.c + position),
            Line(start: figurePoints.c + position, end: figurePoints.d + position),
            Line(start: figurePoints.a + position, end: figurePoints.b + position)
        ]
    }
}

let figures: [Figure] = [
    Figure(position: Point(x: 15, y: 15), figurePoints: (a: Point(x: 0, y: 0), b: Point(x: 1470, y: 0), c: Point(x: 1200, y: 1000), d: Point(x: 0, y: 1000))),
    Figure(position: Point(x: 15, y: 1015), figurePoints: (a: Point(x: 0, y: 0), b: Point(x: 1470, y: 0), c: Point(x: 1200, y: 1000), d: Point(x: 0, y: 1000))),
    Figure(position: Point(x: 15, y: 2015), figurePoints: (a: Point(x: 15, y: 0), b: Point(x: 1485, y: 0), c: Point(x: 1485, y: 1000), d: Point(x: 285, y: 1000))),
    Figure(position: Point(x: 3991, y: 15), figurePoints: (a: Point(x: 0, y: 0), b: Point(x: 798, y: 0), c: Point(x: 798, y: 1485), d: Point(x: 0, y: 1000))),
    Figure(position: Point(x: 3991, y: 1515), figurePoints: (a: Point(x: 0, y: 0), b: Point(x: 798, y: 0), c: Point(x: 798, y: 1200), d: Point(x: 0, y: 1485))),
    Figure(position: Point(x: 2550, y: 2015), figurePoints: (a: Point(x: 15, y: 0), b: Point(x: 685, y: 0), c: Point(x: 600, y: 735), d: Point(x: 150, y: 735)))
]

var linesFromFigures = [Line]()
figures.forEach {linesFromFigures += $0.getLines()}

var lines: [Line] = [
    Line(start: Point(x: 15, y: 0), end: Point(x:  15,  y: 3210)),
    Line(start: Point(x: 0, y: 15), end: Point(x:  6000,  y: 15)),
    Line(start: Point(x: 1500, y: 0), end: Point(x:  1500,  y: 3210)),
    Line(start: Point(x: 15, y: 1015), end: Point(x:  1500,  y: 1015)),
    Line(start: Point(x: 15, y: 2015), end: Point(x:  1500,  y: 2015)),
    Line(start: Point(x: 15, y: 3015), end: Point(x:  1500,  y: 3015)),
    Line(start: Point(x: 2550, y: 0), end: Point(x:  2550,  y: 3210)),
    Line(start: Point(x: 1500, y: 1415), end: Point(x:  2550,  y: 1415)),
    Line(start: Point(x: 1500, y: 2815), end: Point(x:  2550,  y: 2815)),
    Line(start: Point(x: 3991, y: 0), end: Point(x:  3991,  y: 3210)),
    Line(start: Point(x: 2550, y: 515), end: Point(x:  3991,  y: 515)),
    Line(start: Point(x: 2550, y: 1015), end: Point(x: 3991,  y: 1015)),
    Line(start: Point(x: 2550, y: 1515), end: Point(x: 3991,  y: 1515)),
    Line(start: Point(x: 2550, y: 2015), end: Point(x: 3991,  y: 2015)),
    Line(start: Point(x: 2550, y: 2765), end: Point(x: 3991,  y: 2765)),
    Line(start: Point(x: 3250, y: 2015), end: Point(x: 3250,  y: 2765)),
    Line(start: Point(x: 4789, y: 0), end: Point(x: 4789,  y: 3210)),
    Line(start: Point(x: 3991, y: 1515), end: Point(x: 4789,  y: 1515)),
    Line(start: Point(x: 3991, y: 3015), end: Point(x: 4789,  y: 3015)),
    Line(start: Point(x: 5843, y: 0), end: Point(x: 5843,  y: 3210)),
    Line(start: Point(x: 4789, y: 1123), end: Point(x: 5843,  y: 1123)),
    Line(start: Point(x: 5316, y: 15), end: Point(x: 5316,  y: 1123))
] + linesFromFigures

lines.sort { $0.lineSize > $1.lineSize }
lines

func filterLines(lines: [Line]) -> [Line] {
    var givenLines = lines
    if givenLines.isEmpty { return [] }
    var filteredLines = [Line]()
    filteredLines.append(givenLines.removeFirst())

    for line in givenLines {
        var shouldAppend = true
        for filteredLine in filteredLines {
            if filteredLine.doesContainLine(line: line) {
                shouldAppend = false
                break
            }
        }
        if shouldAppend {
            filteredLines.append(line)
        }
    }

    return filteredLines
}



filterLines(lines: lines)


