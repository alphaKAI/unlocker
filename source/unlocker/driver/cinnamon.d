module unlocker.driver.cinnamon;
import unlocker.driver.driver;
import std.process,
       std.string;

class CinnamonDriver : Driver {

  void lock() {
    executeShell("/usr/bin/cinnamon-screensaver-command -l");
  }

  void unlock() {
    executeShell("/usr/bin/cinnamon-screensaver-command -d");
  }

  bool isLocked() {
    auto q = executeShell("LANG=en_US.UTF-8 /usr/bin/cinnamon-screensaver-command -q");
    return q.output.split("\n").join == "The screensaver is active";
  }
}
