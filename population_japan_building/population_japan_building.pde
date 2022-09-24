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

void setup() {
  size(1024, 768, P3D);
  cam = new PeasyCam(this, 500);

  //CSVファイルをTableに読み込む
  table = loadTable("population.csv", "header");

  //地図画像を読み込む
  japanmap = loadImage("map-japan.png");

  cam = new PeasyCam(this, 700);

  colorMode(HSB);
  font = createFont("Osaka", 10);
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
  strokeWeight(1.5);
  //stroke(255);
  noStroke();
  beginShape(QUADS);

  //データから全ての行を取り出しながら、barの高さを人口密度に対応させて描く
  for (int i=0; i<table.getRowCount(); i++) {
    float lat = table.getRow(i).getFloat("lat");
    float lon = table.getRow(i).getFloat("lon");
    float population = table.getRow(i).getFloat("population");

    float x = map(lon, lonFrom, lonTo, 0, japanmap.width);
    float y = map(lat, latFrom, latTo, japanmap.height, 0);

    //barの高さをmap関数で計算。1人ならば高さ1px、7000人ならば300px
    float bar = map(population, 1, 7000, 1, 300); 

    //barの高さに達するまで、階層を描く。
    for (float j=0; j < bar; j = j+ 2) {
      
      //現在の階層の色相と明るさをmap関数で計算。
      float hue = map(j, 1, 300, 120, 0);
      fill(hue, 255, 255, 180);
      stroke(hue, 255, 255, 180);

      //階層の四角形の4頂点を指定
      vertex(x-2, y-2, j);
      vertex(x+2, y-2, j);
      vertex(x+2, y+2, j);
      vertex(x-2, y+2, j);
    }
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

    if (population > 100) {
      pushMatrix();
      fill(0, 0, 255);
      translate(x, y, bar);
      rotateX( radians(-90) );
      rotateZ( radians(-90) );
      text(cityname, 0, 0);
      popMatrix();
    }
  }
}
