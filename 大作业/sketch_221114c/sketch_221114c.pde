import ddf.minim.*;

AudioPlayer player;  //建立音频播放器
Minim minim;   //定义音频对象

PImage album;
int r = 200;  //唱片圆形半径
float albumTheta = 0.0;  
color c1, c2; //动效颜色


void setup() {
  size(800, 800);   //设置画布
  colorMode(HSB, 360, 100, 100, 100);
  myAlbum();  //导入圆形唱片图片

  minim = new Minim(this); 
  player = minim.loadFile("yinyue.mp3", 1024);  //调取音频文件，指定缓存的采样频率为1024
  player.play(); //播放文件
}

void draw() {
  translate(width/2, height/2);    //将坐标原点放在画布中心
  background(360);   //设置背景颜色
  backGround();    
  rotate(albumTheta);     
  image(album, 0, 0); 
  
  //绘制动态音效
  stroke(c1);        //线颜色
  strokeWeight(4);   //线粗
  for (int i=0; i<player.left.size(); i+=6) {
    float rTheta = map(i, 0, player.left.size()-1, 0, 2*PI);  //旋转角度
    pushMatrix();   
    rotate(rTheta);
    line(0, r+10, 0, r + 10 + abs(player.left.get(i))*200);
    popMatrix();   
  }

  albumTheta += 0.02;      
}

void stop() {
  player.close(); //关闭播放器
  minim.stop();   //停止音频
  super.stop();
}

//导入圆形唱片图片
void myAlbum() {
  imageMode(CENTER);  //图片导入模式为中点
  album = loadImage("album.png");      //导入album.png图片
  album.resize(2*r, 2*r);   //将图片长宽放缩为两倍半径

  c1 = album.get(0, 0);  //提取唱片中的颜色
  c2 = color(360, 1, 100, 1);  //白色透明

}

//设置渐变背景
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
