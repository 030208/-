import ddf.minim.*;
AudioPlayer player;  //建立音频播放器
Minim minim;   //定义音频对象

ArrayList<Ball> ballCollection = new ArrayList<Ball>();
float ballRadius = 30;  //小球初始半径

PImage album;  //导入唱片图片和蒙版图片
int r = 200;   //唱片半径
float albumTheta = 0.0;  ////坐标轴旋转角度
color c1, c2; //动效颜色 水波颜色和黑色 c2为了背景渐变效果
color c;  //带有透明度的动效颜色 

void setup() {
  size(800, 800);   //设置画布
  colorMode(HSB, 360, 100, 100, 100);
  myAlbum();  //导入圆形唱片图片
  //音乐相关
  minim = new Minim(this); 
  player = minim.loadFile("yinyue.mp3", 1024);  //调取音频文件，指定缓存的采样频率为1024
  player.play(); //播放文件

  frameRate(8);   //频率
}

void draw() {
  translate(width/2, height/2);    //将坐标原点放在画布中心
  background(360);   //设置背景颜色
  backGround();    //渐变色背景
  //图形相关
  ball();  //小球
  leftCruve();   //左声道水波
  rightCruve();  //右声道水波
  //唱片旋转
  pushMatrix();
  rotate(albumTheta);       //坐标轴旋转
  image(album, 0, 0);    //绘制圆形图片
  popMatrix();
  albumTheta += 0.02;       //坐标轴旋转角度增加
}

//音频停止
void stop() {
  player.close(); //关闭播放器
  minim.stop();   //停止音频
  super.stop();
}
void leftCruve() {
  ArrayList pointCollection1 = new ArrayList();  //创建点的集合
  fill(c);
  noStroke(); 

  for (int i=0; i<player.left.size(); i+=50) {
    float rTheta = map(i, 0, player.left.size()-1, 0, 2*PI); 
    PVector point = new PVector((r+10+abs(player.left.get(i))*150)*cos(rTheta), (r+10+abs(player.left.get(i))*150)*sin(rTheta));
    pointCollection1.add(point);
  }

  beginShape();
  for (int j=0; j<pointCollection1.size(); j++) {
    PVector myPoint = (PVector)pointCollection1.get(j);
    curveVertex(myPoint.x, myPoint.y);
  }
  for (int j=0; j<3; j++) {
    PVector myPoint = (PVector)pointCollection1.get(j);
    curveVertex(myPoint.x, myPoint.y);
  }
  endShape();

  pointCollection1.clear();
}
void rightCruve() {
  ArrayList pointCollection2 = new ArrayList(); 

  fill(c);
  noStroke();

  for (int i=0; i<player.right.size(); i+=50) {
    float rTheta = map(i, 0, player.right.size()-1, 0, 2*PI); 
    PVector point = new PVector((r+10+abs(player.right.get(i))*100)*cos(rTheta), (r+10+abs(player.right.get(i))*100)*sin(rTheta));
    pointCollection2.add(point);
  }

  beginShape();
  for (int j=0; j<pointCollection2.size(); j++) {
    PVector myPoint = (PVector)pointCollection2.get(j);
    curveVertex(myPoint.x, myPoint.y);
  }
  for (int j=0; j<3; j++) {
    PVector myPoint = (PVector)pointCollection2.get(j);
    curveVertex(myPoint.x, myPoint.y);
  }
  endShape();

  pointCollection2.clear();
}
void ball() {
  int dice = (int)random(0, 8);  //骰子随机生成数字
  if (dice == 1) {  //骰子生成数字1时生成小球
    float ballTheta = random(0, 2*PI);
    ballCollection.add(new Ball(ballTheta, ballRadius, r));
  }

  //循环绘制小球
  for (Ball myball : ballCollection) {
    myball.display();
  }
  //消除部分小球
  for (int i = 0; i < ballCollection.size(); i++) {
    Ball removeBall = (Ball)ballCollection.get(i);
    if (removeBall.isDead()) {
      ballCollection.remove(i);
    }
  }
}
class Ball {
  float ballTheta;          //小球运动角度
  float ballRadius;         //小球半径
  float r;                  //唱片半径
  PVector ballLocation;     //小球位置
  PVector speed;            //小球运动速度
  float lifespan;           //小球生命周期

  Ball(float _ballTheta, float _ballRadius, float _r) {
    ballTheta = _ballTheta;
    ballRadius = _ballRadius;
    r = _r;
    ballLocation = new PVector(r * cos(ballTheta), r * sin(ballTheta));
    speed = new PVector(cos(ballTheta)*2, sin(ballTheta)*2);
    lifespan = 50;
  }
  //展示小球，更新 
  void display() {
    noStroke();
    fill(c);
    ellipse(ballLocation.x, ballLocation.y, ballRadius, ballRadius);
    ballLocation.add(speed);
    ballRadius *= 0.99;
    lifespan -= 1.0;
  }
  //判定小球是否应当消失 
  Boolean isDead() {
    if (lifespan < 0.0) {
      return true;
    } else {
      return false;
    }
  }
}
//导入圆形唱片图片
void myAlbum() {
  imageMode(CENTER);  //图片导入模式为中点
  album = loadImage("album.png");      //导入album.png图片
  album.resize(2*r, 2*r);   //将图片长宽放缩为两倍半径

  c1 = album.get(0, 0);  //提取唱片中的颜色
  c2 = color(0, 0, 0, 40);  //黑色透明
  c = color(hue(c1), saturation(c1), brightness(c1), 50); //提取c1颜色设置透明度
}

//渐变色背景
void backGround() {
  for (int y = -height/2; y < 0; y++) {  //循环
    float n = map(y, -height/2, 0, 0, 1);  
    color newc = lerpColor(c1, c2, n);
    stroke(newc); 
    line(-width/2, y, width/2, y);   
  }
  for (int y = height/2; y >= 0; y--) {
    float n = map(y, height/2, 0, 0, 1);
    color newc = lerpColor(c1, c2, n);
    stroke(newc);
    line(-width/2, y, width/2, y);
  }
  noStroke();
  fill(360, 40);
  rect(-width/2, -height/2, width, height);
}
