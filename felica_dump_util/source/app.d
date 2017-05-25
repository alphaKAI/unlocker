import std.stdio;
import std.datetime;
import libpafe4d;

void main() {
  pasori* p;
  felica* f;

  p = pasori_open();
  if (!p) {
    stderr.writeln("error");
    return;
  }
  pasori_init(p);


  writeln("Please touch your felica card on felica reader");

  while (true) {
    f = felica_polling(p, FELICA_POLLING_ANY, 0, 0);
    if (f) {
      writefln("f->systemcode : %d", f.systemcode);
      write("f->IDm : ");
      for (int idx; idx < 8; idx++) {
        writef("%x", f.IDm[idx]);
      }
      writeln;
      write("f->PMm : ");
      for (int idx; idx < 8; idx++) {
        writef("%x", f.PMm[idx]);
      }
      writeln;
      break;
    }
  }
}
