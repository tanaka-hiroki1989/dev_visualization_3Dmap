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
  cam = new PeasyCam(this, 500);

  //CSVファイルをTableに読み込む
  table = loadTable("population.csv", "header");

  //地図画像を読み込む
  japanmap = loadImage("map-japan.png");

  cam = new PeasyCam(this, 700);
}


void draw() {
  background(0);
  translate(-japanmap.width/2, -height/2);

  //地図の描画
  noStroke();
  beginShape();
  texture(japanmap);
  vertex(0, 0, 0, 0, 0);//vertex(x,y,z,textureのu,textureのv)
  vertex(japanmap.width, 0, 0, japanmap.width, 0);
  vertex(japanmap.width, japanmap.height, 0, japanmap.width, japanmap.height);
  vertex(0, japanmap.height, 0, 0, japanmap.height);
  endShape();

  fill(255);
  
  //データから全ての行を取り出しながら、boxの高さを人口密度に対応させて描く
  for (int i=0; i<table.getRowCount(); i++) {
    float lat = table.getRow(i).getFloat("lat");
    float lon = table.getRow(i).getFloat("lon");
    float population = table.getRow(i).getFloat("population");

    float x = map(lon, lonFrom, lonTo, 0, japanmap.width);
    float y = map(lat, latFrom, latTo, japanmap.height, 0);
    
    //barの高さをmap関数で計算。1人ならば高さ1px、8000人ならば300px
    float bar = map(population, 1, 8000, 1, 300); 

    pushMatrix();
    //地表からの高さがNのboxを描くとすると、boxの中心のz座標はN/2
    translate(x, y, bar/2); 
    box(5,5,bar);
    popMatrix();
  }
}
