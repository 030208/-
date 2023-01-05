import ddf.minim.*;    //导入Minim库（音乐可视化）
AudioPlayer player;    //建立音乐播放器
Minim minim;           //定义音频对象

ArrayList<StarRing> StarRingCollection = new ArrayList<StarRing>();   //建立集合储存多个星环
PImage album;    //创建图片变量，和蒙版变量
int rAlbum = 200;   //唱片半径
float albumTheta = 0.0;  ////坐标轴旋转角度
color c1, c2;  //从唱片中提取颜色，黑色
color c;       //星环和星球的颜色

int minDistance = 40;  //星环最近距离;
int n;    //循环帧数

void setup() {
  size(800, 800);
  translate(width/2, height/2);
  colorMode(HSB, 360, 100, 100, 100);   //设置颜色模式
  myAlbum();    //导入圆形唱片
  minim = new Minim(this);
  player = minim.loadFile("yinyue.mp3", 1024);  //调取音频文件，指定缓存的采样频率为1024
  player.play();     //播放文件
}


void draw() {
  translate(width/2, height/2);
  background(360);
  backGround();    //渐变色背景

  pushMatrix();
  rotate(albumTheta);       //坐标轴旋转
  createStarRing();   //创造星环和星球
  drawStarRing();     //绘制星环和星球
  //albumLoop();   //绘制唱片旁的灰圈  
  image(album, 0, 0);  //绘制圆形图片
  popMatrix();

  albumTheta += 0.015;       //坐标轴旋转角度增加
}

void stop() {   //最终关闭Minim
  player.close();  //关闭播放器
  minim.stop();    //停止音频播放
  super.stop();
}
class StarRing {
  float rStarRing;       //星环半径
  color cRing;           //星环颜色
  float alpha;           //星环颜色透明度
  float rStarMax = 350;  //星环最大半径

  float rStar = 20;      //星球半径
  float starTheta;          //星球出现的角度

  StarRing(float _rStarRing, color _cRing, float _alpha, float _rStar, float _starTheta) {
    rStarRing = _rStarRing;
    cRing = _cRing;
    alpha = _alpha;
    rStar = _rStar;
    starTheta = _starTheta;
  }

  //绘制星环
  void displayRing() {
    if (rStarRing < rStarMax) {   //星环半径大于350时消失
      stroke(cRing);         //设置星环边缘颜色
      noFill();
      strokeWeight(3);   //设置星环粗细
      ellipse(0, 0, rStarRing*2, rStarRing*2);   //绘制星环
      rStarRing++;           //星环半径增加
      alpha *= 0.99;     //星环透明度更新
      cRing = color(hue(c1), saturation(c1), brightness(c1), alpha);  //星环透明度更新
    }
  }

  //绘制星球
  void displayStar() {
    if (rStarRing < rStarMax) {
      noStroke();
      fill(cRing);
      ellipse(rStarRing * cos(starTheta), rStarRing * sin(starTheta), rStar, rStar); //绘制星球
      starTheta -= 0.03;   //星球逆时针旋转
      rStar *= 0.999;      //星球逐渐变小
      noFill();
    }
  }
}
//创建星环
void createStarRing() {
  float rStarRing = rAlbum;     //星环半径
  float alpha = 100;        //星环透明度
  float rStar = random(15, 30);
  float starTheta = random(0, 2*PI);
  color cStar = c;

  if (n > minDistance) {  //两个星环最近距离为50
    if (abs(player.left.get(0)) > 0.2) {   //频率大于0.2则绘制星环
      StarRingCollection.add(new StarRing(rStarRing, cStar, alpha, rStar, starTheta));
      n = 0;
    }
  }
  n++;
}

//绘制星环
void drawStarRing() {
  for (int i = 0; i < StarRingCollection.size(); i++) {
    StarRing nowRing = (StarRing)StarRingCollection.get(i);
    nowRing.displayRing();
    nowRing.displayStar();
    //删去半径过大的元素
    if (nowRing.rStarRing > nowRing.rStarMax) {
      StarRingCollection.remove(i);
    }
  }
}
//导入圆形唱片
void myAlbum() {
  imageMode(CENTER);  //图片导入模式为中点
  album = loadImage("album.png");      //导入album.png图片
  album.resize(2*rAlbum, 2*rAlbum);   //将图片长宽放缩为两倍半径

  mycolor();    //颜色设置

}

//颜色
void mycolor() {
  c1 = album.get(0, 0);
  c2 = color(0, 0, 0, 40);       //黑色透明
  c = color(hue(c1), saturation(c1), brightness(c1), 100);  //将从唱片中心点提取的颜色变透明
}

//唱片旁的灰圈
void albumLoop() {
  stroke(300);
  noFill();
  strokeWeight(15);
  ellipse(0, 0, rAlbum*2, rAlbum*2);
}
//渐变色背景
void backGround() {
  for (int y = -height/2; y < 0; y++) {  //循环
    float n = map(y, -height/2, 0, 0, 1);  //0-1间取值，根据y得到映射值n
    color newc = lerpColor(c1, c2, n);  //渐变颜色提取，n取值为0-1
    stroke(newc);                       //设置线的颜色
    line(-width/2, y, width/2, y);      //画线
  }
  for (int y = height/2; y >= 0; y--) {
    float n = map(y, height/2, 0, 0, 1);
    color newc = lerpColor(c1, c2, n);
    stroke(newc);
    line(-width/2, y, width/2, y);
  }
  noStroke();
  fill(0, 60);
  rect(-width/2, -height/2, width, height);
}
