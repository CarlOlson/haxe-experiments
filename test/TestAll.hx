import utest.Runner;
import utest.ui.Report;

class TestAll {
    public static function main() {
	var runner = new Runner();
	runner.addCase(new TestVisitor());
	Report.create(runner);
	runner.run();
    }
}