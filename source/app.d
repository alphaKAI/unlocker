import std.algorithm,
       std.process,
       std.format,
       std.string,
       std.array,
       std.stdio,
       std.conv,
       std.file,
       std.json;
import unlocker.unlocker,
       unlocker.key;
import libpafe4d;

void main() {
  auto   settingFile = readText("%s/.config/unlocker/config.json".format(environment.get("HOME")));
  auto   parsed      = parseJSON(settingFile);
  string driver      = parsed.object["driver"].str;
  long   interval    = 5;
  
  if ("interval" in parsed.object) {
    interval = parsed.object["interval"].integer;
  }

  Key[] keys;

  foreach (keySet; parsed.object["authorized_keys"].object) {
    string[] key = ["IDm", "PMm"].map!(k => keySet.object[k].str).array;
    keys ~= new Key(key[0], key[1]);
  }

  auto unlocker = new Unlocker(driver, keys, interval);
  unlocker.mainLoop;
}
