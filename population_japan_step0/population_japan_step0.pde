import peasy.*; //PeasyCamライブラリをインストールしてインポート
PeasyCam cam;
Table table;
PImage japanmap;

 //経度の範囲
float lonFrom = 122.0;
float lonTo = 148.0;

 //緯度の範囲
float latFrom = 24.0;
float latTo = 46.0;

void setup() {
  size(1024, 768, P3D);
  cam = new PeasyCam(this,500);
  
  //CSVファイルをTableに読み込む
  table = loadTable("population.csv","header");
  
  //地図画像を読み込む
  japanmap = loadImage("map-japan.png");
  
  cam = new PeasyCam(this, 800);
}


void draw() {
  background(0);
  translate(-japanmap.width/2, -japanmap.height/2);
  
  //地図を表示するための矩形を配置する
  noStroke();
  fill(255);
  beginShape();
  vertex(0, 0, 0);
  vertex(japanmap.width, 0, 0);
  vertex(japanmap.width, japanmap.height, 0);
  vertex(0, japanmap.height, 0);
  endShape();
  
}
