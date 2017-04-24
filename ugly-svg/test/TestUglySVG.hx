import utest.Assert;

class TestUglySVG {
    var svg:UglySVG;

    public function new() {};

    public function setup() {
	svg = UglySVG.create('heart.svg');
    }

    public function teardown() {}

    public function test_accepts_valid_svg_files() {
	Assert.notNull(svg);
    }

    public function skip_rejects_invalid_svg_files() {
	svg = UglySVG.create('bogus.svg');
	Assert.isTrue(svg == null);
    }

    public function test_can_output_svgs_string() {
	Assert.match(~/^<svg/i, svg.toString());
    }

    public function test_removes_cubic_bezier_curves() {
	svg.uglify();
	var xml = Xml.parse(svg.toString());
	for(path in xml.firstElement().elementsNamed('path')) {
	    Assert.match(~/^[^Cc]+$/, path.get('d'));
	}
    }
}
