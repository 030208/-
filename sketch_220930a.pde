void setup(){
  frameRate(10);
  size(600,600);
}
void draw(){
  int r = int(random(255));
  int g = int(random(255));
  int b = int(random(255));
  int a = int(random(255));
  println(r,g,b);
  stroke(r,g,b,a);
  line(width/2,height/2,random(width),random(height));
}
