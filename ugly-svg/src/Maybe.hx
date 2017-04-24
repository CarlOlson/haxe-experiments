enum Maybe<T> {
    None;
    Just(value:T);
}

class MaybeUtil {
    public static function apply<T>(monad:Maybe<T>, fn:(T -> Maybe<T>)):Maybe<T> {
	switch(monad) {
	case Just(value):
	    return fn(value);
	case None:
	    return None;
        }
    }

    public static function map<T>(m1:Maybe<T>, m2:Maybe<T>, fn:(T -> T -> Maybe<T>)):Maybe<T> {
	return apply(m1, function(a) return apply(m2, function(b) return fn(a, b)));
    }
}