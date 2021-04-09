
int boxSize = 20;
int size = 60;

boolean[] a = new boolean[size * size * size * size + 1 ];




void setup() {

  size(800, 800, P3D);

  frameRate(2);

  initialState();
}





void draw() {

  stroke(255);
  fill(0);
  translate(0, 0, -2000);
  for (int z = size / -2; z < size / 2; z++) {
    translate(0, 0, boxSize);
    for (int y = size / -2; y < size / 2; y++) {
      translate(0, boxSize, 0);
      for (int x = size / -2; x < size / 2; x++) {
        translate(boxSize, 0, 0);
        if (getCube(x, y, z, 0, a)) {
          box(boxSize);
        }
      }
      translate(size * -1 * boxSize, 0, 0);
    }
    translate(0, size * -1 * boxSize, 0);
  }

  println("Active cubes is ", activeCount());
  if (frameCount > 600) noLoop();
  changeState();
}


void initialState() {

  //String s = ".#.\n..#\n###";
  String s = "#.#.#.##\n.####..#\n#####.#.\n#####..#\n#....###\n###...##\n...#.#.#\n#.##..##";

  String[] lines = s.split("\n");
  int x = 0, y = 0;
  for (String l : lines) {
    for (int i = 0; i < l.length(); i++) {
      if (l.charAt(i) == '#') {
        setCube(x, y, 0, 0, true, a);
      }
      ++x;
    }
    ++y;
    x = 0;
  }
}


void changeState() {
  boolean[] tmp = new boolean[size * size * size * size + 1];
  for (int w = size / -2; w < size / 2; w++) {
    for (int z = size / -2; z < size / 2; z++) {
      for (int y = size / -2; y < size / 2; y++) {
        for (int x = size / -2; x < size / 2; x++) {
          boolean state = getCube(x, y, z, w, a);
          if (state) {
            int count = activeNeighbours(x, y, z, w);
            if (count != 2 && count != 3) {
              setCube(x, y, z, w, false, tmp);
            } else {
              setCube(x, y, z, w, true, tmp);
            }
          } else {
            int count = activeNeighbours(x, y, z, w);
            if (count == 3) {
              setCube(x, y, z, w, true, tmp);
            }
          }
        }
      }
    }
  }
  System.arraycopy(tmp, 0, a, 0, tmp.length);
}




int activeNeighbours(int x, int y, int z, int w) {
  int count = 0;
  for (int i = -1; i <= 1; i++) {
    for (int j = -1; j <= 1; j++) {
      for (int k = -1; k <= 1; k++) {
        for (int l = -1; l <= 1; l++) {
          if (i == 0 && j == 0 && k == 0 && l == 0) continue;
          if (getCube(x + i, y + j, z + k, w + l, a)) {
            count++;
          }
        }
      }
    }
  }
  return count;
}


int activeCount() {
  int count = 0;
  for (int i = 0; i < a.length; i++) {
    if (a[i]) count++;
  }
  return count;
}

void setCube(int x, int y, int z, int w, boolean value, boolean[] a) {

  int i = getIndex(x, y, z, w);
  if (i >= 0 && i < a.length) {
    a[i] = value;
  }
}


boolean getCube(int x, int y, int z, int w, boolean[] a) {

  int i = getIndex(x, y, z, w);
  if (i >= 0 && i < a.length) {
    return a[i];
  }
  return false;
}


int getIndex(int x, int y, int z, int w) {

  int _x = x + size / 2;
  int _y = y + size / 2;
  int _z = z + size / 2;
  int _w = w + size / 2;

  return _x + (_y * size) + (_z * size * size) + (_w * size * size * size);
}
