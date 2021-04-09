import java.util.Arrays;


char[][] seat; 
int width;
int height;
int size;
String input_file = "input.txt";

int count = 0;

color floor = color(255, 255, 255);
color empty_seat = color(0, 0, 0);
color occupied_seat = color(120, 151, 0);


void setup() {
  
  size(600,600);
  stroke(200);
  
  // Set up seats
  String[] lines = loadStrings(input_file);
  print("Read input\n");
  print(lines.length);
  height = lines.length;
  width = lines[0].length();
  size = 600 / width;
  seat = new char[height][width];
  for (int i = 0; i < lines.length; i++) {
    for (int j = 0; j < lines[i].length(); j++) {
     seat[i][j] = (lines[i]).charAt(j);
     print((lines[i]).charAt(j));
    }
    println();
    println(lines[i]);
  }
  println("Done");
  //noLoop();
  frameRate(4);
}


void draw() {
  background(88);
    //println("Draw " + count);
    for (int y = 0; y < height; y++) {
     int y1 = y * size;
     for (int x = 0; x < width; x++) {
       //print(seat[y][x]);
       int x1 = x * size;
       if (seat[y][x] == 'L') {
           fill(empty_seat);
       } else if (seat[y][x] == '#') {
           fill(occupied_seat);
       } else if (seat[y][x] == '.') {
          fill(floor); 
       }
       rect(x1, y1, size, size);
       
     }
     //println();
  }
  
   count++;
   newSeats();
   
}


void newSeats() {
  //println("New seats");
  char[][] newSeat =  new char[height][width]; 
  for (int y = 0; y < height; y++) {
    for (int x = 0; x < width; x++) {
       char c = seat[y][x];
       if (c == 'L') {
         //if (isNoAdjacentOccupiedSeats(x, y)) {
         if (isNoVisibleOccupiedSeats(x, y)) {
           newSeat[y][x] = '#';
         } else {
           newSeat[y][x] = 'L';
         }
       } else if (c == '#') {
         //if (isFourOrMoreOccupied(x,y)) {
         if (isFiveOrMoreVisibleOccupied(x, y)) {
           newSeat[y][x] = 'L';
         } else {
           newSeat[y][x] = '#';
         }
      } else {
         newSeat[y][x] = '.'; 
      }
      //print(newSeat[y][x]);
    }
    //println();
  }
  
  if (Arrays.deepEquals(newSeat, seat)) {
    println("Number of occupied seats: ", numberOfOccupiedSeats());
    println("Equals");
    noLoop();
  }
  // Copy seats
  for (int i = 0; i < newSeat.length; i++) {
    System.arraycopy(newSeat[i], 0, seat[i], 0, newSeat[i].length); 
  }
}


// Finds number of occupied seats
int numberOfOccupiedSeats() {
  int n = 0;
  for (int i = 0; i < seat.length; i++) {
    for (int j = 0; j < seat[i].length; j++) {
      if (seat[i][j] == '#') ++n;
    }
  }
  return n;
}



/*boolean isNoAdjacentOccupiedSeats(int x, int y) {
  return isNoOccupiedSeats(x, y, 1);
}*/


boolean isNoVisibleOccupiedSeats(int x, int y) {
  //int n = Math.max(Math.max(width - x, x), Math.max(height - y, y));
  //println("checking ", n, " rings out for ", x, " and ", y);
  //return isNoVisibleOccupiedSeats(x, y, n);
  boolean isBlockedView = isVisibleOccupiedW(x, y)
    || isVisibleOccupiedNW(x, y)
    || isVisibleOccupiedN(x, y) 
    || isVisibleOccupiedNE(x, y)
    || isVisibleOccupiedE(x, y)
    || isVisibleOccupiedSE(x, y)
    || isVisibleOccupiedS(x, y)
    || isVisibleOccupiedSW(x, y);
  return !isBlockedView;
}

// Checks for visible occupied seats out to n rows.
/*boolean isNoVisibleOccupiedSeats(int x, int y, int n) {
  
  for (int i = 0; i < n; i++) {
    if (isNoOccupiedSeats(x, y, i) == false) {
      return false;
    }
  }
  return true;
}*/


// Check no occupies seats in ring n
/*boolean isNoOccupiedSeats(int x, int y, int ring_n) {
  if (x - ring_n >= 0 &&                                     seat[y][x - ring_n] == '#') return false;                           // L
  if (x - ring_n >= 0 && y - ring_n >= 0 &&                  seat[y - ring_n][x - ring_n] == '#') return false;          // TL
  if (y - ring_n >= 0 &&                                     seat[y - ring_n][x] == '#') return false;                           // T
  if (y - ring_n >= 0 && x + ring_n <= width - 1 &&          seat[y - ring_n][x + ring_n] == '#') return false;      // TR
  if (x + ring_n <= width - 1 &&                             seat[y][x + ring_n] == '#') return false;                       // R
  if (y + ring_n <= height - 1 && x + ring_n <= width - 1 && seat[y + ring_n][x + ring_n] == '#') return false;  // BR
  if (y + ring_n <= height - 1 &&                            seat[y + ring_n][x] == '#') return false;                  // B
  if (y + ring_n <= height - 1 && x - ring_n >= 0 &&         seat[y + ring_n][x - ring_n] == '#') return false; // BL
  return true;
}*/




boolean isFourOrMoreOccupied(int x, int y) {
  return isNOrMoreOccupiedSeats(x, y, 4); //<>//
}

boolean isFiveOrMoreVisibleOccupied(int x, int y) {
  boolean r =  isNOrMoreVisibleOccupiedSeats(x, y, 5);
  return r;
}


boolean isNOrMoreVisibleOccupiedSeats(int x, int y, int n) {
    return numberOfVisisbleOccupiedSeats(x, y) >= n;
}


boolean isNOrMoreOccupiedSeats(int x, int y, int n) {
  int c = 0;
  if (x - 1 >= 0 && seat[y][x - 1] == '#') c++;
  if (x - 1 >= 0 && y - 1 >= 0 && seat[y - 1][x - 1] == '#') c++;
  if (y - 1 >= 0 && seat[y - 1][x] == '#') c++;
  if (y - 1 >= 0 && x + 1 <= width - 1 && seat[y - 1][x + 1] == '#') c++;
  if (x + 1 <= width - 1 && seat[y][x + 1] == '#') c++;
  if (y + 1 <= height - 1 && x + 1 <= width - 1 && seat[y + 1][x + 1] == '#') c++;
  if (y + 1 <= height - 1 && seat[y + 1][x] == '#') c++;
  if (y + 1 <= height - 1 && x - 1 >= 0 && seat[y + 1][x - 1] == '#') c++;
  return c >= n;
}



/*int numberOfVisibleOccupiedSeatsInRingN(int x, int y, int ring_n) {
  int count = 0;
  if (x - ring_n >= 0 && seat[y][x - ring_n] == '#') count++;
  if (x - ring_n >= 0 && y - ring_n >= 0 && seat[y - ring_n][x - ring_n] == '#') count++;
  if (y - ring_n >= 0 && seat[y - ring_n][x] == '#') count++;
  if (y - ring_n >= 0 && x + ring_n <= width - 1 && seat[y - ring_n][x + ring_n] == '#') count++;
  if (x + ring_n <= width - 1 && seat[y][x + ring_n] == '#') count++;
  if (y + ring_n <= height - 1 && x + ring_n <= width - 1 && seat[y + ring_n][x + ring_n] == '#') count++;
  if (y + ring_n <= height - 1 && seat[y + ring_n][x] == '#') count++; //<>//
  if (y + ring_n <= height - 1 && x - ring_n >= 0 && seat[y + ring_n][x - ring_n] == '#') count++;
  return count;
}*/




// 
int numberOfVisisbleOccupiedSeats(int x, int y) {
  int c = 0;
  c =+ (isVisibleOccupiedW(x, y) ? 1 : 0)
    + (isVisibleOccupiedNW(x, y) ? 1 : 0)
    + (isVisibleOccupiedN(x, y) ? 1 : 0)
    + (isVisibleOccupiedNE(x, y) ? 1 : 0)
    + (isVisibleOccupiedE(x, y) ? 1 : 0)
    + (isVisibleOccupiedSE(x, y) ? 1 : 0)
    + (isVisibleOccupiedS(x, y) ? 1 : 0)
    + (isVisibleOccupiedSW(x, y) ? 1 : 0);
  //println (x, y, "has", c);
  return c; //<>//
}




//
// Routines to check visible occupied seat in a direction.
boolean isVisibleOccupiedW(int x, int y) {
   for (int i = x - 1; i >= 0; i--) {
     char s = seat[y][i];
     if (s == '#') { print("W ");
       return true;
     } else if (s == 'L') {
       break;
     }
   }
   return false;
}
boolean isVisibleOccupiedN(int x, int y) {
   for (int i = y - 1; i >= 0; i--) {
     char s = seat[i][x];
     if (s == '#') {  print("N ");
       return true;
     } else if (s == 'L') {
       break;
     }
   }
   return false;
}
boolean isVisibleOccupiedE(int x, int y) {
   for (int i = x + 1; i < width; i++) {
     char s = seat[y][i];
     if (s == '#') { print("E ");
       return true;
     } else if (s == 'L') {
       break;
     }
   }
   return false;
}
boolean isVisibleOccupiedS(int x, int y) {
   for (int i = y + 1; i < height; i++) {
     char s = seat[i][x];
     if (s == '#') { print("S ");
       return true;
     } else if (s == 'L') {
       break;
     }
   }
   return false;
}
boolean isVisibleOccupiedNW(int x, int y) {
   for (int i = 1;  i < Math.min(x + 1, y + 1); i++) {
     char s = seat[y - i][x - i];
     if (s == '#') { print("NW ");
       return true;
     } else if (s == 'L') {
       break;
     }
   }
   return false;
}
boolean isVisibleOccupiedNE(int x, int y) {
   for (int i = 1;  i < Math.min(width - x, y + 1); i++) {
     char s = seat[y - i][x + i];
     if (s == '#') { print("NE ");
       return true;
     } else if (s == 'L') {
       break;
     }
   }
   return false;
}
boolean isVisibleOccupiedSE(int x, int y) {
   for (int i = 1;  i < Math.min(width - x, height - y); i++) {
     char s = seat[y + i][x + i];
     if (s == '#') { print("SE ");
       return true;
     } else if (s == 'L') {
       break;
     }
   }
   return false;
}
boolean isVisibleOccupiedSW(int x, int y) {
   for (int i = 1;  i < Math.min(x + 1, height - y); i++) {
     char s = seat[y + i][x - i];
     if (s == '#') { print("SW ");
       return true;
     } else if (s == 'L') {
       break;
     }
   }
   return false;
}






void mousePressed() {
  redraw();  // Holding down the mouse activates looping
}
