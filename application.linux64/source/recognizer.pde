int wid = 1;
int hig = 1;
int sx = 1;
int sy = 1;
int h = 360;
int b = 100;
int s = 100;
ArrayList<Box> objects = new ArrayList<Box>();
Boolean [][] matrix = new Boolean [1][1];
PImage img;
color red = color(255, 0, 42);
color blue = color(31, 123, 255);
color yellow = color(255, 255, 0);
color purple = color(255, 0, 255);
color green = color(0, 255, 0);
color pix;
int err = 20;
float [] times = new float [10];
File dir = new File("./Pictures");
String[] list = dir.list();

void setup() {
  for (int q = 0; q < list.length; q++) {
    times[0] = millis();
    colorMode(HSB, h, s, b);
    img = loadImage("./Pictures/"+list[q]);//Setup & Loading ------------------------------------------------------------------
    times[1] = millis();
    println("time to load image: "+(times[1] - times[0]));
    
    img.resize(600, 600);
    wid = int(img.width/ 10)*10;
    hig = int(img.height/ 10)*10;


    objects = new ArrayList<Box>();
    matrix = new Boolean [wid/sx][hig/sx];
    size(wid, hig);
    for (int x = 0; x < wid/sx; x += 1) {
      for (int y = 0; y < hig/sx; y += 1) {
        matrix[x][y] = false;
      }
    }
    times[2] = millis();
    image(img, 0, 0);
    loadPixels();//Color Collector -----------------------------------------------------------------------
    times[3] = millis();
    println("image drawing time: "+(times[3] - times[2]));
    times[4] = millis();
    for (int y = 0; y < hig -5; y+= sy) {
      for (int x = 0; x < wid - 5; x+= sx) {
        loc = x + y*wid;
        pix = pixels[loc];
        if (inColor(pix, blue, 40, 40, 30) || inColor(pix, red, 20, 40, 20)) {//*****
          matrix[x/sx][y/sx] = true;
        }
      }
    }
    times[5] = millis();
    println("Wanted Pixel Collection: "+(times[5] - times[4]));
    b1 = new Box(0, 0, 1, 1);//Object builder ------------------------------------------------------------------------------------
    times[6] = millis();
    for (int y = 0; y < hig -5; y+= sy) {
      for (int x = 0; x < wid - 5; x+= sx) {
        b1 = new Box(x/sx, y/sy, 1, 1);
        if (matrix[x/sx][y/sy]) {
          b1 = buildShape(matrix, b1, 1);
          if (b1.dimx + b1.dimy > 10) {
            objects.add(b1);
          }
          for (int z = b1.posx*sx; z < (b1.posx+b1.dimx)*sx; z++) {
            for (int w = b1.posy*sy; w < (b1.posy+b1.dimy)*sy; w++) {
              matrix[z/sx][w/sx] = false;
            }
          }
        }
      }
    }
    times[7] = millis();
    println("object building time: "+(times[7] - times[6]));
    for (int x = 0; x < objects.size (); x++) {
      objects.get(x).make();
    }
    if (objects.size() > 0) {
      println(list[q]);
      save("./Objects/"+list[q]);
    }
  }
}
Box b1 = new Box(5, 5, 1, 1);
int loc = 0;
void draw() {
}

Boolean [][] submatrix(Boolean[][] matrix, int posx, int posy, int dimx, int dimy) {
  Boolean [][] newmatrix = new Boolean[dimx][dimy];
  for (int x = 0; x < dimx; x++) {
    for (int y = 0; y < dimy; y++) {
      newmatrix[x][y] = matrix[posx + x][posy + y];
    }
  }
  return newmatrix;
}

void printer(Boolean[][] matrix) {
  for (int y = 0; y < matrix[0].length; y++) {
    for (int x = 0; x < matrix.length; x++) {
      print(matrix[x][y]+" ");
    }
    println("");
  }
  println("");
}

boolean inColor(color given, color col, float error, float bri, float sat) {
  if (brightness(given) > bri & saturation(given) > sat) {
    if (abs(hue(given) - hue(col)) % (h-error) < error) {
      return true;
    } else {
      return false;
    }
  }
  return false;
}

boolean isWhite(color given) {
  if (saturation(given) < 10 && brightness(given) > 80) {
    return true;
  } else {
    return false;
  }
}

class Box {
  int posx = 0;
  int posy = 0;
  int dimx = 0;
  int dimy = 0;

  Box(int Tposx, int Tposy, int Tdimx, int Tdimy) {
    posx = Tposx;
    posy = Tposy;
    dimx = Tdimx;
    dimy = Tdimy;
  }

  void make() {
    fill(255, 0, 0, 0);
    stroke(10, 100, 100);
    for (int x = 0; x < 2; x++) {
      rect(posx*sx-x, posy*sy-x, dimx*sx+2*x, dimy*sy+2*x);
    }
  }
}

Box buildShape(Boolean [][] Matrix, Box B, int count) {
  Boolean up = false;
  Boolean down = false;
  Boolean side = false;
  Boolean Lside = false;
  if (B.posx*sx + B.dimx*sx < width - 5) {
    if (BooleanCount(submatrix(Matrix, B.posx, B.posy, B.dimx, B.dimy)) < BooleanCount(submatrix(Matrix, B.posx, B.posy, B.dimx+1, B.dimy))) {
      B.dimx = B.dimx + 1;
      side = true;
    }
  }
  if (B.posy*sy + B.dimy*sy < height - 5 ) {
    if (BooleanCount(submatrix(Matrix, B.posx, B.posy, B.dimx, B.dimy)) < BooleanCount(submatrix(Matrix, B.posx, B.posy, B.dimx, B.dimy+1))) {
      B.dimy = B.dimy + 1;
      up = true;
    }
  }
  if (B.posx*sx > 1) {
    if (BooleanCount(submatrix(Matrix, B.posx, B.posy, B.dimx, B.dimy)) < BooleanCount(submatrix(Matrix, B.posx-1, B.posy, B.dimx+1, B.dimy))) {
      B.posx = B.posx - 1;
      B.dimx = B.dimx + 1;
      Lside = true;
    }
  }
  if (B.posy*sy > 1) {
    if (BooleanCount(submatrix(Matrix, B.posx, B.posy, B.dimx, B.dimy)) < BooleanCount(submatrix(Matrix, B.posx, B.posy-1, B.dimx, B.dimy+1))) {
      B.posy = B.posy - 1;
      B.dimy = B.dimy + 1;
      down = true;
    }
  }
  count = 1;
  if (up || side || down || Lside) {
    return buildShape(Matrix, B, count);
  } else {
    return B;
  }
}

int BooleanCount(Boolean [][] Matrix) {
  int count = 0;
  for (int y = 0; y < Matrix[0].length; y++) {
    for (int x = 0; x < Matrix.length; x++) {
      if (Matrix[x][y]) {
        count++;
      }
    }
  }
  return count;
}

