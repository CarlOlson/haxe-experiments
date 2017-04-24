import sys.io.File;

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
	    trace(path.get('d'));
	    path.set('d', '!');
	}
    }

    public function toString():String {
	return xml.toString();
    }
}