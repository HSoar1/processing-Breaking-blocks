//変数宣言
int blocks_row = 10;
int blocks_col = 11;
int[] blockX = new int[blocks_row * blocks_col];
int[] blockY = new int[blocks_row * blocks_col];
color[] blockColor = new int[blocks_row * blocks_col];
int first_block_x = 10;
int first_block_y = 10;
int block_width = 33;
int block_height = 20;
int block_interval_x = 35;
int block_interval_y = 20;
color block_color = color(random(200), random(200), random(200));
DrawBlock[] block = new DrawBlock[blocks_row * blocks_col];

int bar_width = 60;
int bar_height = 15;
int bar_x = 200;
int bar_y = 470;
color bar_color;


float ball_dia = 12;
float ball_x = bar_x + bar_width/2;
float ball_y = bar_y - ball_dia/2;
float vx = random(-10, 10);
float vy = -3.5;


color back_color = color(random(200), random(200), random(200));
boolean start_click = false;
int score = 0;

class DrawBlock {
  int x, y, w, h;
  color rgb;

  DrawBlock(int block_x, int block_y, int block_width, int block_height, color rgb_color) {
    x = block_x;
    y = block_y;
    w = block_width;
    h = block_height;
    rgb = rgb_color;
  }

  void init() {
    fill(rgb);
    rect(x, y, w, h);
  }
}

void setup() {
  frameRate(100);
  size(400, 500);
//ブロックの配列
  for (int y = 0; y < blocks_row; y++) {
    for (int x = 0; x < blocks_col; x++) {
      int i = x + (y * blocks_col);
      blockColor[i] = block_color;
      blockX[i] = first_block_x + block_interval_x * x;
      blockY[i] = first_block_y + block_interval_y * y;
      block[i] = new DrawBlock(blockX[i], blockY[i], block_width, block_height, blockColor[i]);
    }
  }
}

void draw() {

  background(back_color);

  for (int i = 0; i < block.length; i++) {
    block[i].init();
  }

//バーの色と大きさ
  fill(random(255), random(255), random(255));  
  rect(bar_x, bar_y, bar_width, bar_height);
  bar_x = mouseX - bar_width/2;


  if (bar_x > width - bar_width) {
    bar_x = width - bar_width;
  }
  if (bar_x < 0) {
    bar_x = 0;
  }

//ボールの色と大きさ
  fill(173);
  ellipse(ball_x, ball_y, ball_dia, ball_dia);

  if (start_click) {
    ball_x += vx;
    ball_y += vy;
  }


  if ( ball_x > width || ball_x < 0) {
    vx *= -1;
  }
  if ( ball_y < 0) {
    vy *= -1;
  }
//ゲームオーバー時の動作
  if ( ball_y > height+10) {
    fill(255);
    text("Your Score:"+score, width/2, height/2 + 30);
    text("------------------------------------------------------------",width/11-10,height/3+10);
    textSize(60);
    text("GAME OVER", width/11-10, height/3);
    textSize(15);
    text("PRESS 'R' TO TRY AGAIN", width/4+15, height/3+30);
    noLoop();
  }


  if (ball_x > bar_x-5 && ball_x < bar_x + bar_width + 5) {
    if (ball_y > bar_y && ball_y < bar_y + 6) {
      vx = random(-10, 10);
      vy *= -1;
    }
  }

//ブロックの当たり判定etc..
  for (int y = 0; y < blocks_row; y++) {
    for (int x = 0; x < blocks_col; x++) {
      int i = x + (y * blocks_col);
      blockX[i] = first_block_x + block_interval_x * x;
      blockY[i] = first_block_y + block_interval_y * y;

      if (blockColor[i] == block_color) {
        if (ball_y > blockY[i]-5 && ball_y < blockY[i] + block_height+5) {
          if (ball_x > blockX[i]-5 && ball_x < blockX[i] + block_width+5) {
            vy *= -1;
            blockColor[i] = back_color;
            score += 10;
          }
        }

        if (ball_y > blockY[i] && ball_y < blockY[i] + block_height) {
          if (ball_x > blockX[i]-5 && ball_x < blockX[i]-6 ) {
            vx *= -1;
            blockColor[i] = back_color;
          }

          if (ball_x > blockX[i]+5 + block_width && ball_x < blockX[i] + block_width + 6) {
            vx *= -1;
            blockColor[i] = back_color;
          }
        }
      }    
      block[i] = new DrawBlock(blockX[i], blockY[i], block_width, block_height, blockColor[i]);
    }
  }
  //スコア表示
  textSize(10);
  text("Score:"+score, 10, 10);
}
//こいつはクリックしたときの処理、スタート時、リスタート時に利用
void mousePressed() {
  start_click = !start_click;
}
//ｒキーでリスタートするための処理
void keyPressed() {
  if (key == 'r') {
    loop();
    ball_x = bar_x + bar_width/2;
    ball_y = bar_y ;
    score = 0;
    start_click = !start_click;
    //ここでブロックの再生成
    block_color = color(random(200), random(200), random(200));
    back_color = color(random(200), random(200), random(200));
    for (int y = 0; y < blocks_row; y++) {
      for (int x = 0; x < blocks_col; x++) {
        int i = x + (y * blocks_col);
        blockColor[i] = block_color;
        blockX[i] = first_block_x + block_interval_x * x;
        blockY[i] = first_block_y + block_interval_y * y;
        block[i] = new DrawBlock(blockX[i], blockY[i], block_width, block_height, blockColor[i]);
      }
    }
  } else if (key == 'R') {//上記と同様のもの
    loop();
    ball_x = bar_x + bar_width/2;
    ball_y = bar_y ;
    score = 0;
    start_click = !start_click;
    block_color = color(random(200), random(200), random(200));
    back_color = color(random(200), random(200), random(200));
    for (int y = 0; y < blocks_row; y++) {
      for (int x = 0; x < blocks_col; x++) {
        int i = x + (y * blocks_col);
        blockColor[i] = block_color;
        blockX[i] = first_block_x + block_interval_x * x;
        blockY[i] = first_block_y + block_interval_y * y;
        block[i] = new DrawBlock(blockX[i], blockY[i], block_width, block_height, blockColor[i]);
      }
    }
  }
}
