module unlocker.driver.kdeplasma;
import unlocker.driver.driver;
import std.process;

class KDEPlasmaDriver : Driver {
  private Pid pid;

  void lock() {
    this.pid = spawnProcess(["kscreenlocker_greet"]);
  }

  void unlock() {
    this.pid.kill;
    this.pid = null;
  }

  bool isLocked() {
    return pid !is null && !pid.tryWait.terminated;
  }
  //qdbus | grep kscreenlocker | sed 's/org.kde.//' | xargs kquitapp
  
}