enum Maybe<T> {
    None;
    Just(value:T);
}

class MaybeUtil {
    public static function apply<T, R>(monad:Maybe<T>, fn:(T -> Maybe<R>)):Maybe<R> {
	switch(monad) {
	case Just(value):
	    return fn(value);
	case None:
	    return None;
        }
    }

    public static function map<T, R>(m1:Maybe<T>, m2:Maybe<T>, fn:(T -> T -> Maybe<R>)):Maybe<R> {
	return apply(m1, function(a) return apply(m2, function(b) return fn(a, b)));
    }
}