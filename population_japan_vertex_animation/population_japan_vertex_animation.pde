import peasy.*; //PeasyCamライブラリをインストールしてインポート
PeasyCam cam;
Table table;
PImage japanmap;
PFont font;

//経度の範囲
float lonFrom = 122.0;
float lonTo = 148.0;

//緯度の範囲
float latFrom = 24.0;
float latTo = 46.0;

//barがだんだん伸びるための変数t
float t = 0;

void setup() {
  size(1024, 768, P3D);
  cam = new PeasyCam(this, 500);

  //CSVファイルをTableに読み込む
  table = loadTable("population.csv", "header");

  //地図画像を読み込む
  japanmap = loadImage("map-japan.png");

  cam = new PeasyCam(this, 700);

  colorMode(HSB);
  font = createFont("Osaka", 12);
  textFont(font);
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

  noFill();

  //バーの太さ
  strokeWeight(10);
  beginShape(LINES);

  //データから全ての行を取り出しながら、boxの高さを人口密度に対応させて描く
  for (int i=0; i<table.getRowCount(); i++) {
    float lat = table.getRow(i).getFloat("lat");
    float lon = table.getRow(i).getFloat("lon");
    float population = table.getRow(i).getFloat("population");

    float x = map(lon, lonFrom, lonTo, 0, japanmap.width);
    float y = map(lat, latFrom, latTo, japanmap.height, 0);

    //barの高さをmap関数で計算。1人ならば高さ1px、7000人ならば300px
    float bar = map(population, 1, 7000, 1, 300); 

    //barの上端の色相をmap関数で計算。
    float hueTop = map(population, 1, 7000, 120, 0);
    //barの下端の色相
    float hueBottom = 120;

    //barの高さのt%の値をlerp関数で計算
    float tbar = lerp(0, bar, t);
    //hueTopの色相のt%の値をlerp関数で計算
    float thue = lerp(hueBottom, hueTop, t);

    //barの上端のvertexの色と座標
    stroke(thue, 255, 255, 180);
    vertex(x, y, tbar);

    //barの下端のvertexの色と座標
    stroke(hueBottom, 255, 60, 180);
    vertex(x, y, 0);
  }
  endShape();

  for (int i=0; i<table.getRowCount(); i++) {
    //人口密度と都市名を表示
    float lat = table.getRow(i).getFloat("lat");
    float lon = table.getRow(i).getFloat("lon");
    float population = table.getRow(i).getFloat("population");

    float x = map(lon, lonFrom, lonTo, 0, japanmap.width);
    float y = map(lat, latFrom, latTo, japanmap.height, 0);

    //barの高さをmap関数で計算。1人ならば高さ1px、7000人ならば300px
    float bar = map(population, 1, 7000, 1, 300); 
    String cityname = table.getRow(i).getString("city");

    //barの高さのt%の値をlerp関数で計算
    float tbar = lerp(0, bar, t);
    //populationのt%の値をlerp関数で計算
    float tpopulation = lerp(0, population, t);

    if (population > 500) {
      pushMatrix();
      fill(0, 0, 255);
      translate(x, y, tbar);
      rotateX( radians(-90) );
      text(cityname + ":" +tpopulation, 0, 0);
      popMatrix();
    }
  }

  if ( keyPressed ) {
    if (t < 1.0) {
      t = t + 0.01;
    }
    if (key ==' ') {
      t = 0;
    }
  }
}
