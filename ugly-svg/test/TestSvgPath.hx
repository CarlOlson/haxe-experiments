import utest.Assert;
import SvgPath;
import monads.Monads.*;

class TestSvgPath {
    var point0 = {x: 0.0, y: 0.0};
    var point1 = {x: 1.0, y: 1.0};
    var point2 = {x: 2.0, y: 2.0};

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
}