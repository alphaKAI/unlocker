module unlocker.driver.driver;

interface Driver {
  void lock();
  bool isLocked();
  void unlock();
}
