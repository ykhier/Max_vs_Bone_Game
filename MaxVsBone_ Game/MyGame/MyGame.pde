  Image backgroundImage;
  Image[] hearts = new Image[3];
  Image dog;
  int score = 0,lives = 3;
  Text scoreText;
  Music backgroundMusic,successSound,failSound;
  Image[] bones = new Image[2];
  float[] boneY = new float[2];
  float boneSpeed = 3;
  int dogSpeed = 20;
  boolean gameOver = false;
  String endMessage = "";
  
  void setup() {
    size(1024, 512);
    // add image for background
    backgroundImage = new Image();
    backgroundImage.setImage("cartoonBackground.png");
    backgroundImage.x = 0;
    backgroundImage.y = 0;
    backgroundImage.width = width;
    backgroundImage.height = height;
    
    // add image for three hearts
    for(int i = 0; i < hearts.length;i++){
      hearts[i] = new Image();
      hearts[i].setImage("redHeartForLife.png");
      hearts[i].width = 40;
      hearts[i].height = 40;
      hearts[i].x = 180 + i*50;
      hearts[i].y = 20;
    }
    // add image for dog
    dog = new Image();
    dog.setImage("cartoonDog.png");
    dog.width =110;
    dog.height = 120;
    dog.x = width / 2 - dog.width / 2;
    dog.y = 270;
    
    // add text for score
    scoreText = new Text();
    scoreText.textSize = 32;
    scoreText.font = "Arial";
    scoreText.brush = color(255);
    scoreText.x = 20;
    scoreText.y = 52;
    
    // add background music
    backgroundMusic = new Music();
    backgroundMusic.load("gameMusic.mp3");
    backgroundMusic.loop = true;
    backgroundMusic.play();
    
    // add falling bone
    if(gameOver == false){
      for (int i = 0; i < bones.length; i++) {
        bones[i] = new Image();
        bones[i].setImage("cartoonBone.png");
        bones[i].width = 40;
        bones[i].height = 40;
        bones[i].x = int(random(0, width - bones[i].width));
        boneY[i] = -bones[i].height - i * 100;
      }  
    }
     // load success sound
    successSound = new Music();
    successSound.load("positiveSound.mp3");
    
     // load fail sounds 
    failSound = new Music();
    failSound.load("negativeSound.mp3");
  }
  
  void draw() {
    backgroundImage.draw();
    
    for (int i = 0; i < hearts.length; i++) {
      if (hearts[i] != null) {
        hearts[i].draw();
      }
    }  
    
    scoreText.text = "Points: " + score;
    scoreText.draw();
    
    updateBones();
    
    if (gameOver == true) {
      Text endText = new Text();
      endText.text = endMessage;
      endText.textSize = 64;
      endText.font = "Arial";
      endText.brush = color(255, 0, 0);
      endText.x = width / 2 - 150;
      endText.y = height / 2;
      endText.draw();
  }
    
    dog.draw();
    
  }
  void keyPressed() {
    if (gameOver == true) 
        return;
        
    if (keyCode == LEFT) {
      dog.x -= dogSpeed;
    } else if (keyCode == RIGHT) {
      dog.x += dogSpeed;
    }
  
    dog.x = constrain(dog.x, 0, width - dog.width);
  }
  // updates bone position and checks collision and resets when needed
 void updateBones() {
  for (int i = 0; i < bones.length; i++) {
    boneY[i] += boneSpeed;

    boolean caught = boneY[i] + bones[i].height >= dog.y &&
                     bones[i].x + bones[i].width > dog.x &&
                     bones[i].x < dog.x + dog.width;
                     
    // check if the bone was caught by the dog
    if (caught) {
      if (gameOver == false) {
        successSound.play();
        score += 1;
      }
      // check if "Max" (the dog) reached the winning score
      if (score == 10) {
        gameOver = true;
        endMessage = "You Win!";
      }
      boneY[i] = -bones[i].height;
      bones[i].x = int(random(0, width - bones[i].width));
    }
    
    // check if the bone hit the ground
    if (boneY[i] + bones[i].height >= 410) {
      if (gameOver == false) {
            failSound.play();
        // remove one heart
        if (lives > 0) {
          hearts[lives - 1] = null;
          lives--;
        }
        // check if MAX (the dog) has lost all lives
        if (lives == 0) {
          gameOver = true;
          endMessage = "Game Over!";
        }
      }

      boneY[i] = -bones[i].height;
      bones[i].x = int(random(0, width - bones[i].width));
    }
    if (gameOver == false) {
      bones[i].y = int(boneY[i]);
      bones[i].draw();
    }
  }
}
