package;

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
	    svg.uglify(50);
	    Sys.print(svg.toString());
	} else {
	    Sys.print('File $filename does not exist!');
	}
    }
}