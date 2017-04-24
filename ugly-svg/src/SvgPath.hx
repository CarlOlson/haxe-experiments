typedef Point = { x:Float, y:Float };

typedef PointSlope = { point:Point, slope:Float };

enum Kind = {
    Relative;
    Absolute;
};

enum Path {
    Move(k:Kind, p:Point);
    Line(k:Kind, p:Point);
    Horizontal(k:Kind, x:Float);
    Vertical(k:Kind, y:Float);
    Close;
    Cubic(k:Kind, p1:Point, p2:Point, p3:Point);
}

class SvgPath {
    public static function parse(path:String):Path {
    }
}