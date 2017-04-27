import utest.Assert;
import SvgPath;
import monads.Monads.*;

class TestSvgPath {
    var point0 = {x: 0.0, y: 0.0};
    var point1 = {x: 1.0, y: 1.0};
    var point2 = {x: 2.0, y: 2.0};
    var point3 = {x: 3.0, y: 3.0};
    var point4 = {x: 4.0, y: 4.0};
    var point5 = {x: 5.0, y: 5.0};

    public function new() {}

    public function test_can_parse_move() {
	Assert.same(just([Move(Absolute, {x: 10, y: 10})]),
		    SvgPath.parse("M10 10"));

	Assert.same(just([Move(Relative, {x: 10, y: 10})]),
		    SvgPath.parse("m10 10"));
    }

    public function test_can_parse_floats() {
	Assert.same(just([Move(Absolute, {x: 10, y: 10})]),
		    SvgPath.parse("M10.0 10.0"));
    }

    public function test_ignores_extra_spaces() {
	Assert.same(just([Move(Absolute, point0)]),
		    SvgPath.parse("M 0 0"),
		    "extra space after command letter");

	Assert.same(just([Move(Absolute, point0)]),
		    SvgPath.parse(" M0 0"),
		    "extra space at left of path");

	Assert.same(just([Move(Absolute, point0)]),
		    SvgPath.parse("M0 0 "),
		    "extra space at right of path");
    }

    public function test_can_parse_many_commands() {
	Assert.same(just([Move(Absolute, point0),
			  Move(Absolute, point1)]),
		    SvgPath.parse("M0 0 M1 1"));
    }

    public function test_can_parse_z_close() {
	Assert.same(just([Close]),
		    SvgPath.parse("z"));

	Assert.same(just([Close]),
		    SvgPath.parse("Z"));
    }

    public function test_can_parse_line() {
	Assert.same(just([Line(Absolute, point0)]),
		    SvgPath.parse("L0 0"));

	Assert.same(just([Line(Relative, point0)]),
		    SvgPath.parse("l0 0"));
    }

    public function test_can_parse_cubic_bezier() {
	Assert.same(just([Cubic(Absolute, point0, point1, point2)]),
		    SvgPath.parse("C0 0 1 1 2 2"));

	Assert.same(just([Cubic(Relative, point0, point1, point2)]),
		    SvgPath.parse("c0 0 1 1 2 2"));
    }

    public function test_can_turn_path_to_string() {
	var path;

	Assert.same('', SvgPath.asString([]));
	Assert.same('', SvgPath.asString(null));

	path = [Move(Absolute, point0),
		Move(Relative, point0)];
	Assert.same(just(path), SvgPath.parse(SvgPath.asString(path)), 'move');

	path = [Line(Absolute, point0),
		Line(Relative, point0)];
	Assert.same(just(path), SvgPath.parse(SvgPath.asString(path)), 'line');

	path = [Close];
	Assert.same(just(path), SvgPath.parse(SvgPath.asString(path)), 'close');

	path = [Cubic(Absolute, point0, point1, point2),
		Cubic(Relative, point0, point1, point2)];
	Assert.same(just(path), SvgPath.parse(SvgPath.asString(path)), 'cubic');
    }

    public function test_support_commas_for_points() {
	Assert.isTrue(SvgPath.parse('M 272,195 L 272.75,196.75 L 272,195 z') != none(),
		      'unable to parse commas');
    }

    public function test_support_negative_point_values() {
	Assert.isTrue(SvgPath.parse('M -3,0 M0 -4') != none(),
		      'unable to parse negative numbers');
    }

    public function test_support_continuous_relative_commands() {
	Assert.same(just([Cubic(Relative, point0, point1, point2),
			  Cubic(Relative, point3, point4, point5)]),
		    SvgPath.parse("c0 0 1 1 2 2 3 3 4 4 5 5"),
		    'unable to parse continuous cubics');

	Assert.same(just([Line(Relative, point0),
			  Line(Relative, point1)]),
		    SvgPath.parse("l0 0 1 1"),
		    'unable to parse continuous lines');
    }

    public function test_support_parse_tabs_and_newlines() {
	var input = 'M27 69C42.3035 66.0491
        73.1983 44.6614 67.3472
		26.0008';
	Assert.isTrue(SvgPath.parse(input) != none());
    }
}