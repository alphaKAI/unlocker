module unlocker.key;
import std.format;

class Key {
  string name;
  string IDm;
  string PMm;

  this (string IDm, string PMm) {
    this.IDm = IDm;
    this.PMm = PMm;
  }

  this (string name, string IDm, string PMm) {
    this.name = name;
    this(IDm, PMm);
  }

  override bool opEquals(Object _that) {
    assert((cast(typeof(this))_that) !is null);
    typeof(this) that = cast(typeof(this))_that;

    return that.IDm == this.IDm && that.PMm == this.PMm;
  }
  
  bool isAuthorizedKey(Key[] authorized_keys) {
    foreach (authorized_key; authorized_keys) {
      if (authorized_key == this) {
        return true;
      }
    }

    return false;
  }

  override string toString() {
    return "<[Key] name:%s, IDm:%s, PMm:%s>".format(this.name, this.IDm, this.PMm);
  }
}
