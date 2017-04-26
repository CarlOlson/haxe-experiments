
typedef PointImpl<T> = {x:T, y:T};

abstract Point(PointImpl<Float>) from PointImpl<Float> to PointImpl<Float> {
    inline public function new(x:Float, y:Float)
	this = {x: x, y: y};

    public static var origin(default, never) = new Point(0, 0);

    public var x(get, never):Float;
    public var y(get, never):Float;

    private function get_x()
	return this.x;

    private function get_y()
	return this.y;

    @:from
    static public function fromPointImpl<T>(point:PointImpl<T>):Point {
	return new Point(cast point.x, cast point.y);
    }
}