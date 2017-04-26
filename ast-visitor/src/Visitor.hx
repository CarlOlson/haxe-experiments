using haxe.macro.Expr;
import monads.Maybe;

class Visitor<T> {

    public function new() {
    }

    public function visit(expr:Expr):Maybe<T> {
	switch(expr.expr) {
	case EConst( c ):
	    return visitConst(c);
	case EArray( e1, e2 ):
	    return visitArray(e1, e2);
	case EBinop( op, e1, e2 ):
	    return visitBinop(op, e1, e2);
	case EField( e, field ):

	case EParenthesis( e ):
	    return visitParen(e);
	case EObjectDecl( fields ):

	case EArrayDecl( values ):

	case ECall( e, params ):

	case ENew( t, params ):

	case EUnop( op, postFix, e ):

	case EVars( vars ):

	case EFunction( name, f ):

	case EBlock( exprs ):

	case EFor( it, expr ):

	case EIn( e1, e2 ):

	case EIf( econd, eif, eelse ):

	case EWhile( econd, e, normalWhile ):

	case ESwitch( e, cases, edef ):

	case ETry( e, catches ):

	case EReturn( e ):

	case EBreak:

	case EContinue:

	case EUntyped( e ):

	case EThrow( e ):

	case ECast( e, t ):

	case EDisplay( e, isCall ):

	case EDisplayNew( t ):

	case ETernary( econd, eif, eelse ):

	case ECheckType( e, t ):

	case EMeta( s, e ):

	}
	return None;
    }

    public function visitChildren(expr : Expr) : Maybe<T> {
	switch(expr.expr) {
	case EConst( c ):

	case EArray( e1, e2 ):

	case EBinop( op, e1, e2 ):

	case EField( e, field ):

	case EParenthesis( e ):

	case EObjectDecl( fields ):

	case EArrayDecl( values ):

	case ECall( e, params ):

	case ENew( t, params ):

	case EUnop( op, postFix, e ):

	case EVars( vars ):

	case EFunction( name, f ):

	case EBlock( exprs ):

	case EFor( it, expr ):

	case EIn( e1, e2 ):

	case EIf( econd, eif, eelse ):

	case EWhile( econd, e, normalWhile ):

	case ESwitch( e, cases, edef ):

	case ETry( e, catches ):

	case EReturn( e ):

	case EBreak:

	case EContinue:

	case EUntyped( e ):

	case EThrow( e ):

	case ECast( e, t ):

	case EDisplay( e, isCall ):

	case EDisplayNew( t ):

	case ETernary( econd, eif, eelse ):

	case ECheckType( e, t ):

	case EMeta( s, e ):

	}
	return None;
    }

    public function visitConst(const:Constant):Maybe<T> {
	return None;
    }

    public function visitArray(e1:Expr, e2:Expr):Maybe<T> {
	return None;
    }

    public function visitBinop(op:Binop, e1:Expr, e2:Expr):Maybe<T> {
	return None;
    }

    public function visitParen(e:Expr):Maybe<T> {
	return None;
    }
}