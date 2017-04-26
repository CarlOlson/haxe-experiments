import sys.io.File;
import SvgPath;

class UglySVG {
    private var xml:Xml;

    private function new(xml:Xml) {
	this.xml = xml;
    }

    public static function create(path:String):UglySVG {
	try {
	    var content = File.getContent(path);
	    var xml = Xml.parse(content);
	    return new UglySVG(xml);
	} catch(error : Dynamic) {
	    return null;
	}
    }

    public function uglify() {
	for(path in xml.firstElement().elementsNamed('path')) {
	    path.set('d', '!');
	}
    }

    public function toString():String {
	return xml.toString();
    }

    private static function linearizeCubic(kind:Kind, startPoint:Point, startCtrl:Point,
					   endCtrl:Point, endPoint:Point, minLength:Float):Array<Path> {
	if (kind == Relative) {
	    startPoint = Point.origin;
	}

	var pathLength = cubicLength(startPoint, startCtrl, endCtrl, endPoint);

	if (minLength * 2 > pathLength) {
	    return [Line(kind, endPoint)];
	}

	return null;
    }

    private static function cubicLength(startPoint:Point, startCtrl:Point, endCtrl:Point, endPoint:Point):Float {
	var lastPoint = startPoint,
	    length = 0.0,
	    n = 16;

	for (i in 1...(n+1)) {
	    var currPoint = cubicPoint(i / n, startPoint, startCtrl, endCtrl, endPoint);
	    length += lastPoint.distance(currPoint);
	    lastPoint = currPoint;
	}

	return length;
    }

    private static function cubicPoint(t:Float, startPoint:Point, startCtrl:Point, endCtrl:Point, endPoint:Point):Point {
	var dt = 1 - t,
	    dt2 = dt * dt,
	    dt3 = dt2 * dt,
	    t2 = t * t,
	    t3 = t2 * t,
	    x = startPoint.x * dt3 + startCtrl.x * 3 * dt2 * t + endCtrl.x * 3 * dt * t2 + endPoint.x * t3,
	    y = startPoint.y * dt3 + startCtrl.y * 3 * dt2 * t + endCtrl.y * 3 * dt * t2 + endPoint.y * t3;

	return {x: x, y: y};
    }
}