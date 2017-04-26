package;

import utest.Assert;

class TestPoint {
    public function new() {}

    var point1 = new Point(1.0, 1.0);
    var point2 = new Point(-1.0, -2.0);

    public function test_negation() {
	Assert.same(point1, -(-point1), 'double negation is identity');
	Assert.same(new Point(-1.0, -1.0), -point1);
    }

    public function test_subtraction() {
	Assert.same(point1 - Point.origin, point1, 'subtract origin is identity');
	Assert.same(Point.origin - point1, -point1, 'subtracting from origin is negation');
	Assert.same(new Point(2.0, 3.0), point1 - point2);
    }

}