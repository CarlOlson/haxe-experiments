import utest.Assert;
import SvgPath;
import Maybe;

class TestSvgPath {
    public function new() {}

    public function test_can_parse_move() {
	Assert.same(Just([Move(Absolute, {x: 10, y: 10})]),
		    SvgPath.parse("M10 10"));

	Assert.same(Just([Move(Relative, {x: 10, y: 10})]),
		    SvgPath.parse("m10 10"));
    }

    public function test_can_parse_floats() {
	Assert.same(Just([Move(Absolute, {x: 10, y: 10})]),
		    SvgPath.parse("M10.0 10.0"));
    }

    public function test_ignores_extra_spaces() {
	Assert.same(Just([Move(Absolute, {x:0, y:0})]),
		    SvgPath.parse("M 0 0"),
		    "extra space after command letter");

	Assert.same(Just([Move(Absolute, {x:0, y:0})]),
		    SvgPath.parse(" M0 0"),
		    "extra space at left of path");

	Assert.same(Just([Move(Absolute, {x:0, y:0})]),
		    SvgPath.parse("M0 0 "),
		    "extra space at right of path");
    }

    public function test_can_parse_many_commands() {
	Assert.same(Just([Move(Absolute, {x: 0, y: 0}),
			  Move(Absolute, {x: 1, y: 1})]),
		    SvgPath.parse("M0 0 M1 1"));
    }

    public function test_can_parse_z_close() {
	Assert.same(Just([Close]),
		    SvgPath.parse("z"));

	Assert.same(Just([Close]),
		    SvgPath.parse("Z"));
    }
}