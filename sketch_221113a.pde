PVector[] points;
int numPoint = 10;
int maxPoint = 100000;
int frameNum = 0;
int batch = 100;
float bias = 0.5;

PVector seed;
boolean fractal = false;

void setup(){
  size(1000, 1000);
  initiatePoints();
}

void initiatePoints(){
  frameNum = 0;
  points = new PVector[numPoint];
   
   for (int i = 0; i < points.length; i++){
     float angle = 2 * PI / numPoint;
     float radius = random(width/4, 3 * width/4);
     points[i] = new PVector(width/2 + radius * cos(angle * i), height/2 + radius * sin(angle * i));
   }
   
   seed = new PVector(random(width), random(height));
   background(255);
   showPoints();
   showStart();
}

void draw() {
  for (int i = 0; i < batch; i ++) {
    if (frameNum < maxPoint) {
      if (fractal) {
        int index = (int)random(numPoint);
        fractal(index);
        showStart();
        frameNum ++;
      }
    }
  }
  println(frameNum);
}

void showPoints() {
  for (int i = 0; i < points.length; i ++) {
    strokeWeight(20);
    stroke(155);
    point(points[i].x, points[i].y);
  }
}

void showStart() {
  strokeWeight(5);
  stroke(0);
  point(seed.x, seed.y);
}

void fractal(int k) {
  PVector tmp = PVector.sub(points[k], seed);
  tmp.mult(bias);
  seed.add(tmp);
}

void keyPressed() {
  if (key == 'r') {
    initiatePoints();
  }
  if (key == 'f') {
    fractal = true;
  }
  if (key == 'a') {
    numPoint ++;
    initiatePoints();
  }
  if (key == 'z') {
    if (numPoint>2) {
      numPoint --;
      initiatePoints();
    }
  }
}
