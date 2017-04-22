import utest.Assert;

class TestVisitor {
    var visitor : Visitor<Int>;

    public function new() {};

    public function setup() {
	visitor = new Visitor<Int>();
    }

    public function test_visit_returns_none_by_default() {
	var input = macro 0;
	switch visitor.visit(input) {
            case Just(_):
		Assert.fail();
            case None:
		Assert.pass();
	}
    }

    public function teardown() {
    }
}