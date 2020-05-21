
// Constants
final int LEFT_EDGE = -512;
final int TOP_EDGE = -384;
final int RIGHT_EDGE = 512;
final int BOTTOM_EDGE = 384;

final int NUM_BALLS = 15;

float[] ballX = new float[NUM_BALLS];
float[] ballY = new float[NUM_BALLS];
color[] ballColor = new color[NUM_BALLS];
float[] ballVectorX = new float[NUM_BALLS];
float[] ballVectorY = new float[NUM_BALLS];
float[] ballSize = new float[NUM_BALLS];

int[][] ballCollide = new int[NUM_BALLS][NUM_BALLS-1];

void setup() {
  // Can't use RIGHT_EDGE and BOTTOM_EDGE here; wish Processing
  // were more sensible regarding constants
  size(1024, 768);
  // When we draw balls, do so from their centers
  ellipseMode(RADIUS);
  for (int i = 0; i < NUM_BALLS; i++) {
   ballX[i] = random(LEFT_EDGE + ballSize[i]/2 + ballVectorX[i], RIGHT_EDGE - ballSize[i]/2 - ballVectorX[i]);
   ballY[i] = random(TOP_EDGE + ballSize[i]/2 + ballVectorY[i], BOTTOM_EDGE - ballSize[i]/2 - ballVectorY[i]);
   ballSize[i] = random(20,30);
   ballColor[i] = color(random(255), random(255), random(255));
   ballVectorX[i] =  random(2,6);
   ballVectorY[i] =  random(2,6);
  }
}

void draw() {
  background(#ffffff);          // white
  translate(width/2, height/2); // draw from center of window
  
  ballsMove();   // Move all bouncy balls
  drawBall();   // Tell all bouncy balls to draw themselves
}

public void ballsMove() {
  for (int i = 0; i < NUM_BALLS; i++) {
    if (ballY[i] >= BOTTOM_EDGE - ballSize[i]) {
       ballY[i] = BOTTOM_EDGE - ballSize[i];
       ballVectorY[i] *= -1;
    }
    if (ballY[i] <= TOP_EDGE + ballSize[i]) {
      ballY[i] = TOP_EDGE + ballSize[i]; 
      ballVectorY[i] *= -1;
    }
    
    if (ballX[i] >= RIGHT_EDGE - ballSize[i]) {
       ballX[i] = RIGHT_EDGE - ballSize[i];
       ballVectorX[i] *= -1;
    }
    if (ballX[i] <= LEFT_EDGE + ballSize[i]) {
       ballX[i] = LEFT_EDGE + ballSize[i];
       ballVectorX[i] *= -1;
    }
    for (int j = i + 1; j < NUM_BALLS; j++) {
      double distance = distance(ballX[i], ballY[i], ballX[j], ballY[j]);
      double overlap = distance - (ballSize[i] + ballSize[j]);
      if (overlap <= 0) {
        if (ballX[i] > ballX[j]) {
          ballX[i] += -overlap / 2;
          ballX[j] -= -overlap / 2;
        } else {
          ballX[j] += -overlap / 2;
          ballX[i] -= -overlap / 2;
        }
      float m1 = ballSize[i];
      float m2 = ballSize[j];
      float x1 = ballVectorX[i];
      float x2 = ballVectorX[j];
      float y1 = ballVectorY[i];
      float y2 = ballVectorY[j];
      ballVectorX[i] = ( ((m1-m2) * x1) + (2 * m2 * x2) ) / (m1 + m2);
      ballVectorX[j] = ( ((m2-m1) * x2) + (2 * m1 * x1) ) / (m1 + m2);
      ballVectorY[i] = ( ((m1-m2) * y1) + (2 * m2 * y2) ) / (m1 + m2);
      ballVectorY[j] = ( ((m2-m1) * y2) + (2 * m1 * y1) ) / (m1 + m2);
      }
    }
    
    ballX[i] += ballVectorX[i];
    ballY[i] += ballVectorY[i];
  }
}
public double distance(float oneX, float oneY, float twoX, float twoY) {
  return Math.sqrt(square(oneX - twoX) + square(oneY - twoY));
}

// Tell all bouncy balls to draw themselves
void drawBall() {
  for (int i = 0; i < NUM_BALLS; i++) {
    fill(ballColor[i]);
    ellipse(ballX[i],ballY[i], ballSize[i], ballSize[i]);
  }
}
