module unlocker.driver.i3lock;
import unlocker.driver.driver;
import std.process;

class I3LockDriver : Driver {

  void lock() {
    pid = spawnProcess(["i3lock", "--nofork"]);
  }

  void unlock() {
    pid.kill;
    pid = null;
  }

  bool isLocked() {
    return pid !is null && !pid.tryWait.terminated;
  }

private:
  Pid pid;
}
