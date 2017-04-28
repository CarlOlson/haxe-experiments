package;

import SvgPath;

class Main {
    public static function main() {
	var args = Sys.args();

	if (args == null || args.length == 0) {
	    Sys.print('File not given');
	    return;
	}

	var filename = args[args.length - 1];

	if (sys.FileSystem.exists(filename)) {
	    var svg = UglySVG.create(filename);
	    svg.uglify(10 - Std.random(4));
	    svg.transformPaths(jitter);
	    Sys.print(svg.toString());
	} else {
	    Sys.print('File $filename does not exist!');
	}
    }

    public static function jitterPoint(point:Point):Point {
	var dx = (Std.random(1000) / 250) - 2,
	    dy = (Std.random(1000) / 250) - 2;
	return {x: point.x + dx, y: point.y + dy};
    }

    public static function jitter(path:Array<Path>):Array<Path> {
	var jitterPath = [];

	for (cmd in path) {
	    switch(cmd) {
	    case Line(kind, point):
		jitterPath.push(Line(kind, jitterPoint(point)));
	    default:
		jitterPath.push(cmd);
	    }
	}

	return jitterPath;
    }
}