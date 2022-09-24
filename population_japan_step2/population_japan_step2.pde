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
  
  //地図の描画
  noStroke();
  fill(255);
  beginShape();
  texture(japanmap);
  vertex(0, 0, 0, 0, 0);//vertex(x,y,z,textureのu,textureのv)
  vertex(japanmap.width, 0, 0, japanmap.width, 0);
  vertex(japanmap.width, japanmap.height, 0, japanmap.width, japanmap.height);
  vertex(0, japanmap.height, 0, 0, japanmap.height);
  endShape();
  
  //東京の緯度は
  float latTokyo = 35.69;
  //東京の経度は
  float lonTokyo = 139.69;
  
  //東京のx座標、y座標は
  float x = map(lonTokyo, lonFrom, lonTo, 0, japanmap.width);
  float y = map(latTokyo, latFrom, latTo, japanmap.height,0);
  
  
  fill(255,0,0);
  
  //東京の場所にboxを表示
  pushMatrix();
  translate(x, y, 0);
  box(10,10,10);
  popMatrix();
  
  
  
}
