import utest.Assert;
import SvgPath;
import monads.Monads.*;

@:access(UglySVG)
class TestUglySVG {
    var svg:UglySVG;

    var startPoint:Point;
    var startCtrl:Point;
    var endCtrl:Point;
    var endPoint:Point;

    public function new() {};

    public function setup() {
	svg = UglySVG.create('heart.svg');

	startPoint = {x:120.0, y:160.0};
	startCtrl = {x:35.0, y:200.0};
	endCtrl = {x:220.0, y:260.0};
	endPoint = {x:220.0, y:40.0};
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
	var sizes = [];
	var xml = Xml.parse(svg.toString());
	for(path in xml.firstElement().elementsNamed('path')) {
	    var p = [];
	    bind(SvgPath.parse(path.get('d')), p);
	    sizes.push(p.length);
	}

	svg.uglify(10);
	xml = Xml.parse(svg.toString());
	for(path in xml.firstElement().elementsNamed('path')) {
	    var d = path.get('d');
	    Assert.match(~/^[^Cc]+$/, d);

	    var p = [];
	    if (bind(SvgPath.parse(d), p))
		Assert.isTrue(p.length > sizes.pop());
	    else
		Assert.fail();
	}
    }

    public function test_uglify_preserves_non_bezier_paths() {
	svg = UglySVG.create('nonbezier.svg');
	var original = svg.toString();
	svg.uglify();

	Assert.equals(original, svg.toString());
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

    public function test_linearizeCubic_with_short_paths() {
	var length = UglySVG.cubicLength(startPoint, startCtrl, endCtrl, endPoint);

	function testKind(kind) {
	    Assert.same([Line(kind, endPoint)],
			UglySVG.linearizeCubic(kind, startPoint, startCtrl, endCtrl, endPoint, length * 0.51));

	    Assert.same([Line(kind, endPoint)],
			UglySVG.linearizeCubic(kind, startPoint, startCtrl, endCtrl, endPoint, length * 1.01));
	}

	testKind(Absolute);

	startCtrl -= startPoint;
	endCtrl -= startPoint;
	endPoint -= startPoint;
	testKind(Relative);
    }

    public function test_linearizeCubic_with_long_paths() {
	var length = UglySVG.cubicLength(startPoint, startCtrl, endCtrl, endPoint);

	var path = UglySVG.linearizeCubic(Absolute, startPoint, startCtrl, endCtrl, endPoint, length / 9);

	Assert.equals(10, path.length);
    }

    public function test_supports_nested_paths() {
	svg = UglySVG.create('nested.svg');
	var beforeLength = svg.toString().length;
	svg.uglify(10);

	Assert.isTrue(svg.toString().length > beforeLength);
    }

    public function test_transfromPaths() {
	var transform = UglySVG.create('heart.svg'),
	    original = UglySVG.create('heart.svg');

	transform.transformPaths(function (path) return UglySVG.uglifyPath(path, 1));
	original.uglify(1);

	Assert.same(original.toString(), transform.toString(),
		    'transformPaths not implemented correctly');
    }
}
