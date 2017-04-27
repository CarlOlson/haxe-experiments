using StringTools;
import monads.Monads;
import monads.Monads.*;

typedef PointSlope = { point:Point, slope:Float };

enum Kind {
    Relative;
    Absolute;
}

enum Path {
    Move(k:Kind, p:Point);
    Line(k:Kind, p:Point);
    Horizontal(k:Kind, x:Float);
    Vertical(k:Kind, y:Float);
    Close;
    Cubic(k:Kind, p1:Point, p2:Point, p3:Point);
}

class SvgPath {
    private var lastPath:String;
    private var pointRegex:EReg;

    private function new() {
	pointRegex = ~/^(-?\d+\.?\d*)(?:,|\s+)(-?\d+\.?\d*)/;
    }

    private function _parse(path:String):Maybe<Array<Path>> {
	path = path.rtrim();

	if (path == '')
	    return Just([]);

	function rec(pair) {
	    return _parse(pair.right).apply(
		function(nodes)
		return Just([pair.left].concat(nodes)));
	}

	var nodes = none();
	if (nodes == None)
	    nodes = acceptMove(path).apply(rec);
	if (nodes == None)
	    nodes = acceptLine(path).apply(rec);
	if (nodes == None)
	    nodes = acceptClose(path).apply(rec);
	if (nodes == None)
	    nodes = acceptCubic(path).apply(rec);
	return nodes;
    }

    public static function parse(path:String):Maybe<Array<Path>> {
	return (new SvgPath())._parse(path);
    }

    private function acceptMove(path:String):Maybe<Pair<Path, String>> {
        path = path.ltrim();

	if (!atCommand(path, 'm'))
	    return None;

	var point = null,
	    rest = path.substring(1);

	if (bindPair(acceptPoint(rest), point, rest)) {
	    return justPair(Move(kindOf(path), point), rest);
	} else {
	    return None;
	}
    }

    private function acceptLine(path:String):Maybe<Pair<Path, String>> {
	var point = null,
	    kind,
	    rest;

	path = path.ltrim();

	if (atCommand(path, 'l')) {
	    kind = kindOf(path);
	    rest = path.substring(1);
	    lastPath = path.charAt(0);
	} else if (atPoint(path) && atCommand(lastPath, 'l')) {
	    kind = kindOf(lastPath);
	    rest = path;
	} else {
	    return None;
	}

	if (bindPair(acceptPoint(rest), point, rest)) {
	    return justPair(Line(kind, point), rest);
	} else {
	    return None;
	}
    }

    private function acceptCubic(path:String):Maybe<Pair<Path, String>> {
	var kind,
	    point1 = null,
	    point2 = null,
	    point3 = null,
	    rest;

    	path = path.ltrim();

        if (atCommand(path, 'c')) {
	    kind = kindOf(path);
	    rest = path.substring(1);
	    lastPath = path.charAt(0);
	} else if (atPoint(path) && atCommand(lastPath, 'c')) {
	    kind = kindOf(lastPath);
	    rest = path;
	} else
	    return None;

	if (bindPair(acceptPoint(rest), point1, rest) &&
	    bindPair(acceptPoint(rest), point2, rest) &&
	    bindPair(acceptPoint(rest), point3, rest)) {
	    return justPair(Cubic(kind, point1, point2, point3), rest);
	} else {
	    return None;
	}
    }

    private function acceptClose(path:String):Maybe<Pair<Path, String>> {
	path = path.ltrim();

	if (atCommand(path, 'z')) {
	    return justPair(Close, path.substring(1));
	} else {
	    return None;
	}
    }

    private function acceptPoint(path:String):Maybe<Pair<Point, String>> {
	path = path.ltrim();

	if (pointRegex.match(path)) {
	    var x = Std.parseFloat(pointRegex.matched(1));
	    var y = Std.parseFloat(pointRegex.matched(2));
	    return justPair(new Point(x, y), pointRegex.matchedRight());
	} else {
	    return None;
	}
    }

    private static function kindOf(path:String):Kind {
	return ~/[A-Z]/.match(path.charAt(0)) ? Absolute : Relative;
    }

    private static function atCommand(path:String, cmd:String):Bool {
	return (path != null &&
		(path.startsWith(cmd.toLowerCase()) ||
		 path.startsWith(cmd.toUpperCase())));
    }

    private function atPoint(path:String):Bool {
	return path != null && pointRegex.match(path);
    }

    private static function justPair<T>(node:T, rest:String):Maybe<Pair<T, String>> {
	return Just(makePair(node, rest));
    }

    public static function asString(path:Array<Path>):String {
	if (path == null || path.length == 0)
	    return '';

	var str = switch(path[0]) {
	case Move(kind, p):
	cmdAsString('m', kind) + pointAsString(p);
	case Line(kind, p):
	cmdAsString('l', kind) + pointAsString(p);
	case Cubic(kind, p1, p2, p3):
	'${cmdAsString("c", kind)}${pointAsString(p1)} ${pointAsString(p2)} ${pointAsString(p3)}';
	case Close:
	'z';
	default:
	'';
	};

	return str + asString(path.slice(1));
    }

    private static function pointAsString(p:Point):String {
	return '${p.x} ${p.y}';
    }

    private static function cmdAsString(cmd:String, kind:Kind):String {
	switch(kind) {
	case Absolute:
	    return cmd.toUpperCase();
	case Relative:
	    return cmd.toLowerCase();
	}
    }
}