/* @pjs preload="StickMan.png","Spikes.png"; */

var FLOOR;

var player;
var platforms = new Array();
var spike;

const gameStates = {
    START: 'start',
    PLAY: 'play',
    END: 'end'
};

var gameState = gameStates.START;
PImage startImage;
PImage endImage;
var endCounter = 0;

void setup() {
  FLOOR = SCREEN_HEIGHT - 100;

  size(SCREEN_WIDTH, SCREEN_HEIGHT);
  background(255, 255, 255);
  fill(125, 125, 125);
  noStroke();

  startImage = loadImage("Start.png");
  endImage = loadImage("End.png");

  player = new Player(loadImage("StickMan.png"), 10, FLOOR)

  platforms.push(new Platform(100, 370, 100, 5));
  platforms.push(new Platform(200, 350, 150, 5));
  platforms.push(new Platform(400, 400, 30, 5));

  spike = new Spike(loadImage("Spikes.png"), 530, FLOOR);
}

void draw() {
  if (gameState == gameStates.START) {
    background(255, 255, 255);
    image(startImage, 100, 100);
    return;
  }
  // Oo, we died, so punish the player a bit
  if (gameState == gameStates.END) {
    background(255, 255, 255);
    image(endImage, 100, 200);
    endCounter -= 1;
    if (endCounter <= 0) {
      gameState = gameStates.PLAY;
    }
    return;
  }

  calculate()

  background(255, 255, 255);
  drawPlatforms(platforms);
  spike.draw();

  player.draw();
}

function calculate() {
  calculateMovement();
  calculateJump();
  calculateGravity();
  calculatePlatforms(platforms);
  calculateSpike(spike);
}

void keyPressed() {
  if (gameState == gameStates.START) {
    gameState = gameStates.PLAY;
  }
  playerMovementPress(keyCode, player, platforms, MARGIN, SCREEN_WIDTH, FLOOR);
}

void keyReleased() {
  playerMovementRelease(keyCode, player, MARGIN, SCREEN_WIDTH, FLOOR);
}

void mouseClicked() {
  if (gameState == gameStates.START) {
    gameState = gameStates.PLAY;
  }
}

// Spike functions
function calculateSpike(spike) {
  if (isCollide(player, spike)) {
    console.log(spike.x + " " + spike.y + " " +
      spike.width + " " + spike.height);
    player.x = 10;
    player.y = FLOOR;
    endCounter = 50;
    gameState = gameStates.END;
  }
}
