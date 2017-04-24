using StringTools;
using Maybe;

typedef Point = { x:Float, y:Float };

typedef PointSlope = { point:Point, slope:Float };

typedef Pair<T, R> = { left:T, right:R };

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

	return acceptMove(path).apply(rec);
    }

    private static function acceptMove(path:String):Maybe<Pair<Path, String>> {
        path = path.ltrim();
	var point = acceptPoint(path.substring(1));

	switch(point) {
	case Just({left: point, right: rest}):
	    if (path.startsWith('M')) {
		return justPair(Move(Absolute, point), rest);
	    } else if (path.startsWith('m')) {
		return justPair(Move(Relative, point), rest);
	    } else {
		return None;
	    }
	default:
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

    private static function justPair<T>(node:T, rest:String):Maybe<Pair<T, String>> {
	return Just({ left: node, right: rest });
    }
}