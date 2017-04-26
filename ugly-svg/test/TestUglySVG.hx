import utest.Assert;
import SvgPath;

@:access(UglySVG)
class TestUglySVG {
    var svg:UglySVG;

    var startPoint = {x:120.0, y:160.0};
    var startCtrl = {x:35.0, y:200.0};
    var endCtrl = {x:220.0, y:260.0};
    var endPoint = {x:220.0, y:40.0};

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

    public function test_linearize_minimum_length() {
	var length = UglySVG.cubicLength(startPoint, startCtrl, endCtrl, endPoint);

	function testKind(kind) {
	    Assert.same([Line(kind, endPoint)],
			UglySVG.linearizeCubic(kind, startPoint, startCtrl, endCtrl, endPoint, length * 0.51));

	    Assert.same([Line(kind, endPoint)],
			UglySVG.linearizeCubic(kind, startPoint, startCtrl, endCtrl, endPoint, length * 1.01));
	}

	testKind(Absolute);
	testKind(Relative);
    }

    public function test_distance() {
	Assert.equals(UglySVG.distance(Point.origin, {x:1.0, y:0.0}),
		      1.0);
	Assert.floatEquals(UglySVG.distance(Point.origin, {x:2.0, y:3.0}),
			   Math.sqrt(13));
    }

    public function test_cubicLength() {
	var length = UglySVG.cubicLength(startPoint, startCtrl, endCtrl, endPoint);

	Assert.floatEquals(272.87, length, 0.65);
    }

    public function test_cubicPoint() {
	function pointAtTime(t) {
	    return UglySVG.cubicPoint(t, startPoint, startCtrl, endCtrl, endPoint);
	}

	Assert.same(startPoint, pointAtTime(0), 'equals start point at t = 0');
	Assert.same(endPoint, pointAtTime(1.0), 'equals end point at t = 1');
    }
}
