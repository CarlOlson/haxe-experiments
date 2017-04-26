import utest.Runner;
import utest.ui.Report;

class TestAll {
  public static function main() {
    var runner = new Runner();
    runner.addCase(new TestUglySVG());
    runner.addCase(new TestSvgPath());
    runner.addCase(new TestPoint());
    Report.create(runner);
    runner.run();
  }
}
