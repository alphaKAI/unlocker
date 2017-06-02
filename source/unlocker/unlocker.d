module unlocker.unlocker;
import unlocker.key,
       unlocker.driver.driver,
       unlocker.driver.cinnamon,
       unlocker.driver.i3lock;
import libpafe4d;
import std.algorithm,
       std.format,
       std.array,
       std.conv;
import core.thread;
import std.stdio;

class Unlocker {
  private {
    Driver  driver;
    static immutable provided_drivers = ["cinnamon", "i3lock"];
    Key[]   authorized_keys;
    pasori* p;
    felica* f;
    long    interval;
  }


  static isProvided(string driver) {
    foreach (provided_driver; provided_drivers) {
      if (provided_driver == driver) {
        return true;
      }
    }

    return false;
  }

  void init_felica_reader() {
    this.p = pasori_open;
    if (!this.p) {
      throw new Exception("Failed to open pasori");
    }
    pasori_init(this.p);
  }

  ~this() {
    pasori_close(this.p);
  }

  this (string driver, Key[] authorized_keys, long interval) {
    init_felica_reader;

    if (isProvided(driver)) {
      switch (driver) {
        case "cinnamon":
          this.driver = new CinnamonDriver;
          break;
        case "i3lock":
          this.driver = new I3LockDriver;
          break;
        default: break;
      }
    } else {
      throw new Exception("The specified driver - %s is not provided".format(driver));
    }

    this.authorized_keys = authorized_keys;
    this.interval        = interval;
  }

  bool isLocked() {
    return this.driver.isLocked;
  }

  void unlock(Key key) {
    if (key.isAuthorizedKey(this.authorized_keys)) {
      writeln("unlock with - ", key);
      driver.unlock;
    }
  }

  void lock(Key key) {
    if (key.isAuthorizedKey(this.authorized_keys)) {
      writeln("lock with - ", key);
      driver.lock;
    }
  }

  void mainLoop() {
    while (true) {
      this.f = felica_polling(this.p, FELICA_POLLING_ANY, 0, 0);

      if (f !is null) {
        Key key = makeKeyFromFelica(this.f);

      	if (this.isLocked) {
          this.unlock(key);
        } else {
          this.lock(key);
        }

        Thread.sleep(dur!"seconds"(this.interval));
      } else {
        // skip
      }
    }
  }
}

static Key makeKeyFromFelica(felica* f) {
  if (f is null) {
    throw new Exception("given felica* is null");
  }

  string IDm = f.IDm.to!(ubyte[]).map!(x => "%x".format(x)).join,
         PMm = f.PMm.to!(ubyte[]).map!(x => "%x".format(x)).join;

  return new Key(IDm, PMm);
}
