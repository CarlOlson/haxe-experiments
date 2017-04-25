using StringTools;
import monads.Monads.*;
import monads.Maybe;
import monads.Pair;

typedef Point = { x:Float, y:Float };

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
    private function new() {}

    public static function parse(path:String):Maybe<Array<Path>> {
	path = path.rtrim();

	if (path == '')
	    return Just([]);

	function rec(pair) {
	    return parse(pair.right).apply(
		function(nodes)
		return Just([pair.left].concat(nodes)));
	}

	var nodes = None;
	if (nodes == None)
	    nodes = acceptMove(path).apply(rec);
	if (nodes == None)
	    nodes = acceptLine(path).apply(rec);
	if (nodes == None)
	    nodes = acceptCubic(path).apply(rec);
	if (nodes == None)
	    nodes = acceptClose(path).apply(rec);
	return nodes;
    }

    private static function acceptMove(path:String):Maybe<Pair<Path, String>> {
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

    private static function acceptLine(path:String):Maybe<Pair<Path, String>> {
	path = path.ltrim();

	if (!atCommand(path, 'l'))
	    return None;

	var point = null,
	    rest = path.substring(1);

	if (bindPair(acceptPoint(rest), point, rest)) {
	    return justPair(Line(kindOf(path), point), rest);
	} else {
	    return None;
	}
    }

    private static function acceptCubic(path:String):Maybe<Pair<Path, String>> {
    	path = path.ltrim();

        if (!atCommand(path, 'c'))
	    return None;

	var point1 = null,
	    point2 = null,
	    point3 = null,
	    rest = path.substring(1);

	if (bindPair(acceptPoint(rest), point1, rest) &&
	    bindPair(acceptPoint(rest), point2, rest) &&
	    bindPair(acceptPoint(rest), point3, rest)) {
	    return justPair(Cubic(kindOf(path), point1, point2, point3), rest);
	} else {
	    return None;
	}
    }

    private static function acceptClose(path:String):Maybe<Pair<Path, String>> {
	path = path.ltrim();

	if (atCommand(path, 'z')) {
	    return justPair(Close, path.substring(1));
	} else {
	    return None;
	}
    }

    private static function acceptPoint(path:String):Maybe<Pair<Point, String>> {
	path = path.ltrim();
	var regexp = ~/^(\d+\.?\d*) (\d+\.?\d*)/;

	if (regexp.match(path)) {
	    var x = Std.parseFloat(regexp.matched(1));
	    var y = Std.parseFloat(regexp.matched(2));
	    return justPair({x: x, y: y}, regexp.matchedRight());
	} else {
	    return None;
	}
    }

    private static function kindOf(path:String):Kind {
	return ~/[A-Z]/.match(path.charAt(0)) ? Absolute : Relative;
    }

    private static function atCommand(path:String, cmd:String):Bool {
	return (path.startsWith(cmd.toLowerCase()) ||
		path.startsWith(cmd.toUpperCase()));
    }

    private static function justPair<T>(node:T, rest:String):Maybe<Pair<T, String>> {
	return Just(makePair(node, rest));
    }
}