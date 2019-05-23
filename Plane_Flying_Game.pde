import ddf.minim.*;

AudioPlayer player; Minim minim;
boolean up, down, left, right;
int level;
int clock;
int speed, coinSpeed;
int [] starsx;
int [] starsy;
int [] badGuysX;
int [] badGuysY;
int coinx, coiny;
int x, y, coinCount, lives, maxLives;
boolean bonusAdded;
int greenCount, yellowCount, redCount;

void setup() {
  level = 1;
  minim = new Minim(this);
  switch (level) {
    case 1: player = minim.loadFile("song1.mp3", 2048); break;
    case 2: player = minim.loadFile("song2.mp3", 2048); break;
    case 3: player = minim.loadFile("song3.mp3", 2048); break;
    case 4: player = minim.loadFile("song4.mp3", 2048); break;
    case 5: player = minim.loadFile("song5.mp3", 2048); break;
    case 6: player = minim.loadFile("song6.mp3", 2048); break;
    case 7: player = minim.loadFile("song7.mp3", 2048); break;
    case 8: player = minim.loadFile("song8.mp3", 2048); break;
    case 9: player = minim.loadFile("song9.mp3", 2048); break;
    case 10: player = minim.loadFile("song10.mp3", 2048); badGuysX = new int [5]; badGuysY = new int [5]; break;
  }
  player.play();  
  size(1280,720);
  noStroke();
  frameRate(5*level + 55);
  clock = 0;
  speed = 4;
  coinCount = 0;
  maxLives = 3;
  lives = maxLives;
  starsx = new int[20];
  starsy = new int[20];
  badGuysX = new int[3];
  badGuysY = new int[3];
  coinSpeed = 4;
  x=100; y=300;
  for (int j = 0; j < starsx.length; j++) {
    starsx[j] = 85*(j+1);
  }
  for (int j = 0; j < starsy.length; j++) {
    starsy[j] = (int)(Math.random()*720); 
  }
  for (int j = 0; j < badGuysX.length; j++) {
    badGuysX[j] = (int)(Math.random()*1280);
  }
  for (int j = 0; j < badGuysY.length; j++) {
    badGuysY[j] = (int)(Math.random()*720);
  }
  coinx = (int)(Math.random()*1280);
  coiny = 0;
  draw();
}

void draw() {
  // background color
  if (level==1) {background(#00ECFF);}
  if (level==2) {background(#038FFF);}
  if (level==3) {background(#0319FF);}
  if (level==4) {background(#000000);}
  if (level==5) {background(#315F00);}
  if (level==6) {background(#78AA43);}
  if (level==7) {background(#A5810A);}
  if (level==8) {background(#A5460A);}
  if (level==9) {background(#930785);}
  if (level==10) {background(#7222DE);}
  if (level > 10) {background((int)(Math.random()*256), (int)(Math.random()*256), (int)(Math.random()*256));}
  
  // stars
  fill(#FFFFFF);
  for (int j = 0; j < starsx.length; j++) {
    rect(starsx[j], starsy[j], 10, 10);
  }
  for (int j = 0; j < starsy.length; j++) {
    if (starsy[j] > 720) {starsy[j] = 0;}
    starsy[j] += 4;
  }
  
  // coin
  if (coiny > 720) {coiny = 0; coinx = (int)(Math.random()*1280);}
  coiny+=coinSpeed;
  fill(#FFE600);
  ellipse(coinx, coiny, 30, 30);
  if (coinCount < 5) {
     fill(#00ff00); coinSpeed = 4;
  }
  else if (coinCount < 10) {
     fill(#ffff00); coinSpeed = 5;
   }
  else {
     fill(#ff0000); coinSpeed = 6;
  }
  ellipse(coinx, coiny, 10, 10);
  
  // getcoin
  if (Math.abs((x+10)-coinx) < 25 && Math.abs((y+10)-coiny) < 25) {
    coinCount++;
    coiny-=720;
    coinx = (int)(Math.random()*1280);
  } 
  greenCount = coinCount;
  if (greenCount > 5) {greenCount = 5;}
  yellowCount = coinCount - 5;
  if (yellowCount < 0) {yellowCount = 0;}
  if (yellowCount > 5) {yellowCount = 5;}
  redCount = coinCount - 10;
  if (redCount < 0) {redCount = 0;}
  
  // bad guys
  for (int j = 0; j < badGuysX.length; j++) {
    badGuysX[j] += (j+1);
    if (badGuysX[j] > 1280) {badGuysX[j] = 0;}
    if (y <= badGuysY[j]) {badGuysY[j]-=1;}
    else {badGuysY[j]+=1;}
  }
  for (int j = 0; j < badGuysX.length; j++) {
    fill(#FFFFFF);
    ellipse(badGuysX[j], badGuysY[j], 30, 30);  
    fill(#FF8400);
    ellipse(badGuysX[j], badGuysY[j], 20, 20);
  }
  
  // hit bad guy
  for (int j = 0; j < badGuysX.length; j++) {
    if (Math.abs((x+10)-badGuysX[j]) < 25 && Math.abs((y+10)-badGuysY[j]) < 25) {
      death();
    }
  }  
  
  // player
  fill(#6C6C6C);
  rect(x, y, 20, 20);
  if (up && y >= 10) {y-=speed;}
  if (down && y <= 710) {y+=speed;}
  if (left) {x-=speed;}
  if (right) {x+=speed;}
  if (x > 1280) {x = 0;}
  if (x < -10) {x = 1270;}
  
  // increment level
  if (coinCount>=15) {
    levelUp();
    frameRate(level*5+55);
  }
  
  // final level added bonus
  if (level == 10 && coinCount > 9 &&!bonusAdded) {
    badGuysX = new int [7]; 
    badGuysY = new int [7];
    for (int j = 0; j < badGuysY.length; j++) {
      badGuysY[j] = (int)(Math.random()*720);
    }
    bonusAdded = true;
  }
  
  // lives left
  fill(#ff0000);
  for (int j = 0; j < maxLives; j++) {
    rect(1280-(30*j + 30), 10, 20, 20);
  }
  fill(#6C6C6C);
  for (int j = 0; j < lives; j++) {
    rect(1280-(30*j + 30), 10, 20, 20);
  }
  fill(#00ff00);
  for (int j = 0; j < lives-1; j++) {
    rect(1280-(30*j + 30), 10, 20, 20);
  }
  
  // coins collected
  fill(#6c6c6c);
  ellipse(45, 45, 45, 45);
  fill(#00ff00);
  ellipse(45, 45, greenCount*9, greenCount*9);
  fill(#ffff00);
  ellipse(45, 45, yellowCount*9, yellowCount*9);
  fill(#ff0000);
  ellipse(45, 45, redCount*9, redCount*9);
}

void levelUp() {
  coinCount = 0;
  level++;
  for (int j = 0; j < badGuysY.length; j++) {
    badGuysY[j] = (int)(Math.random()*720);
  }
  player.close();
  minim.stop();
  // super.stop();
  minim = new Minim(this);
  switch (level) {
    case 1: player = minim.loadFile("song1.mp3", 2048); break;
    case 2: player = minim.loadFile("song2.mp3", 2048); break;
    case 3: player = minim.loadFile("song3.mp3", 2048); break;
    case 4: player = minim.loadFile("song4.mp3", 2048); break;
    case 5: player = minim.loadFile("song5.mp3", 2048); break;
    case 6: player = minim.loadFile("song6.mp3", 2048); break;
    case 7: player = minim.loadFile("song7.mp3", 2048); break;
    case 8: player = minim.loadFile("song8.mp3", 2048); break;
    case 9: player = minim.loadFile("song9.mp3", 2048); break;
    case 10: player = minim.loadFile("song10.mp3", 2048); badGuysX = new int [5]; badGuysY = new int [5]; break;
  }
  player.play();
}

void death() {
  lives--;
  if (lives <= 0) {gameOver();}
  else {
    coinCount = 0;
    level--;
    levelUp();
    bonusAdded = false;
  }
}

void gameOver() {
  level = 1;
  coinCount = 0;
  
  player.close();
  minim.stop();
  super.stop();
}

void keyPressed() {
  if (key==CODED) {
    if (keyCode==UP) {up = true;} 
    if (keyCode==LEFT) {left = true;}
    if (keyCode==RIGHT) {right = true;} 
    if (keyCode==DOWN) {down = true;} 
  }
}

void keyReleased() {
  if (key==CODED) {
    if (keyCode==UP) {up = false;} 
    if (keyCode==LEFT) {left = false;}
    if (keyCode==RIGHT) {right = false;} 
    if (keyCode==DOWN) {down = false;} 
  }
}