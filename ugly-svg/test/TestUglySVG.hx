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
	var p1 = {x:1.0, y:1.0},
	    p2 = {x:0.0, y:0.0},
	    p3 = {x:1.0, y:0.0};

	var minLength = 1.5;

        Assert.same([Line(Absolute, {x:1, y:0})],
		    UglySVG.linearizeCubic(Absolute, {x:0.0, y:0.0}, p1, p2, p3, minLength));

	Assert.same([Line(Relative, {x:1, y:0})],
		    UglySVG.linearizeCubic(Relative, {x:0.0, y:0.0}, p1, p2, p3, minLength));
    }

    public function test_distance() {
	Assert.equals(UglySVG.distance({x:0.0, y:0.0}, {x:1.0, y:0.0}),
		      1.0);
	Assert.floatEquals(UglySVG.distance({x:0.0, y:0.0}, {x:2.0, y:3.0}),
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
