import utest.Assert;
import Maybe;
using haxe.macro.Expr;

class MyTestVisitor extends Visitor<Int> {
    override public function visitConst(const : Constant) : Maybe<Int> {
	switch(const) {
	case CInt(v):
	    return Just(Std.parseInt(v));
	default:
	    return None;
	}
    }

    override public function visitArray(e1:Expr, e2:Expr) : Maybe<Int> {
	switch(e2.expr) {
	case EConst(CInt(v)):
	    return Just(Std.parseInt(v));
	default:
	    return None;
	}
    }

    override public function visitBinop(op: Binop, e1: Expr, e2: Expr) : Maybe<Int> {
	return MaybeUtil.map(visit(e1), visit(e2), function(a, b) return Just(a + b));
    }

    override public function visitParen(e:Expr):Maybe<Int> {
	return visit(e);
    }
}

class TestVisitor {
    var visitor : Visitor<Int>;

    public function new() {};

    public function setup() {
	visitor = new MyTestVisitor();
    }

    public function teardown() {
    }

    public function test_visit_returns_none_by_default() {
	var input = macro 0;
	visitor = new Visitor<Int>();
	switch(visitor.visit(input)) {
	case Just(_):
	    Assert.fail();
	case None:
	    Assert.pass();
	}
    }

    public function test_visitChildren_returns_none_by_default() {
	var input = macro 0 + 0;
	visitor = new Visitor<Int>();
	switch(visitor.visitChildren(input)) {
	case Just(_):
	    Assert.fail();
	case None:
	    Assert.pass();
	}
    }

    public function test_visit_calls_visitConst() {
	Assert.same(Just(0), visitor.visit(macro 0));
    }

    public function test_visit_calls_visitArray() {
	Assert.same(Just(5), visitor.visit(macro array[5]));
    }

    public function test_visit_calls_visitBinop() {
	Assert.same(Just(2), visitor.visit(macro 1 + 1));
    }

    public function test_visit_calls_visitParen() {
	Assert.same(Just(3), visitor.visit(macro 1 + (1 + 1)));
    }
}