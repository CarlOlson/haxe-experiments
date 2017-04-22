enum Maybe<T> {
    None;
    Just(value : T);
}

class MaybeUtil {
    public static function apply<T>(monad:Maybe<T>, fn:(T -> Maybe<T>)) : Maybe<T> {
	switch(monad) {
	case Just(value):
	    return fn(value);
	case None:
	    return None;
        }
    }
}