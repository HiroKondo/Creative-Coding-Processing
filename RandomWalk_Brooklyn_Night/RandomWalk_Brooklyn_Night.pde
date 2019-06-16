/*
 * Random walk in Brooklyn.
 * The only rule of searching the next node is to avoid going back to the previous node.
 * But, when the circle reaches a dead end, it heads back to the last node.
 * 
 * This program is written to make a movie.
 * The generated images are saved in the folder "frames/[The current time]", ex frames/2019_6_12_23_58/
 * To make a movie, please use other software to make a movie, such as Adobe After Effects.
 *
 * This program is heavy. So, if you just want to check the output, set SAVE_FRAME to false and change the SCALE_FACTOR to 1. 
 *
 * Programmed by Hiroyuki Kondo 
 * 
 * Map data © OpenStreetMap contributors
 *  
 */


// Import a library for map.
import java.util.Map;

String cityName = "brooklyn";
String roadType = "car_road";
String nodeDataCSV = cityName + "_" + roadType + "_nodes.csv";
String adjacentNodesDataCSV = cityName + "_" + roadType + "_adjacent_nodes_list.csv";
String nodeAreaCSV = cityName + "_" + roadType + "_area.csv";

String pngFileFolder = "frames/" + year() + "_" + month() + "_" + day() + "_" + hour() + "_" + minute() + "/";

// Class to store the city data
CityMap cityMap = new CityMap();

// Pedestrians information
People pedestrians;

// Number of pedestrians
static int NUMBER_OF_PEDESTRIANS = 100000;

int drawPedestriansNum = 1;

// The scale factor to save a big size image
static int SCALE_FACTOR = 4;

// Moving speed
static float MOVING_SPEED = 0.3 * SCALE_FACTOR;

// Background color
color backgroundColor = color(8, 8, 30);

// PGraphics for background color and the roads
PGraphics pgBackground;


// Counter for loop
int loopCount = 0;


static int FRAMERATE = 30;
static int SITUATION_SEC = 4;

// Decide when the program will stop
static int STOP_LOOP_COUNT = 700;

// Flag to decide whether save the frame or not
static boolean SAVE_FRAME = true;

// Counter for save the frame
int frameCounter = 0;

void setup(){
  
  
  // Set the size of the window
  size(1000, 1000);
  
  background(backgroundColor);
  smooth();

  // Set the size of the map.
  // This funstion must be called at the beginning. 
  cityMap.setMapSize(width * SCALE_FACTOR, height * SCALE_FACTOR);

  // Import the latitude and the longitude data of the corners of the map
  cityMap.setMapCornersFromCSV(nodeAreaCSV);

  // Import the the latitude and longitude data of the nodes in the map.
  // Then, calculate the x and y coordinate on the map
  // This function must be done after the function "setMapCornersFromCSV" because this function use the corner data
  cityMap.importNodeData(nodeDataCSV);

  // Import the Data about the adjacent nodes of each node
  cityMap.importAdjacentNodeData(adjacentNodesDataCSV);
   
  // Make moving pedestrians
  pedestrians = new People(MOVING_SPEED);
  pedestrians.setupPeople(NUMBER_OF_PEDESTRIANS);
  
  
  // Draw a road on a PGraphics
  // This PGraphics will not be changed.
  pgBackground = createGraphics(width * SCALE_FACTOR, height * SCALE_FACTOR);
  pgBackground.beginDraw();
  pgBackground.smooth();
  pgBackground.background(backgroundColor);
  colorMode(RGB, 255, 255, 255);
  cityMap.drawLines(pgBackground, color(40, 40, 60), SCALE_FACTOR/4);  
  pgBackground.endDraw();
  
  
}


void draw(){

  // Draw Circles
  PGraphics pgPedestrians = createGraphics(width * SCALE_FACTOR, height * SCALE_FACTOR);
  pgPedestrians.beginDraw();
  pgPedestrians.smooth();
  pedestrians.drawPeopleLimitedNum(pgPedestrians, true, drawPedestriansNum);
  pgPedestrians.endDraw();
 
  // Combine two PGraphics into one image
  PImage screen = pgBackground.get();
  screen.blend(pgPedestrians, 0, 0, width * SCALE_FACTOR, height * SCALE_FACTOR, 0, 0, width * SCALE_FACTOR, height * SCALE_FACTOR, BLEND);

    
  float sizeTemp = 1500 - 1500 * float(loopCount - FRAMERATE * SITUATION_SEC * 1) / (FRAMERATE * SITUATION_SEC * 4 - FRAMERATE * SITUATION_SEC * 1);
  
  if(loopCount < FRAMERATE * SITUATION_SEC * 1){
    drawPedestriansNum = 1;
    image(screen, -1500, -1500, 4000, 4000);  
  } else if (loopCount < FRAMERATE * SITUATION_SEC * 2){    
    drawPedestriansNum = 10;    
    image(screen, -sizeTemp, -sizeTemp, sizeTemp * 2 + 1000, sizeTemp * 2 + 1000);
  } else if (loopCount < FRAMERATE * SITUATION_SEC * 3){
    drawPedestriansNum = 100;
    image(screen, -sizeTemp, -sizeTemp, sizeTemp * 2 + 1000, sizeTemp * 2 + 1000);
  } else if (loopCount < FRAMERATE * SITUATION_SEC * 4){
    drawPedestriansNum = 1000;
    image(screen, -sizeTemp, -sizeTemp, sizeTemp * 2 + 1000, sizeTemp * 2 + 1000);
  } else {
    image(screen, 0, 0, width, height);
    drawPedestriansNum = 10000;
  }
  
  if (SAVE_FRAME){
    save(pngFileFolder + String.format("%04d", frameCounter) +".png");
    frameCounter++;
  }
  
  if (loopCount>=STOP_LOOP_COUNT){
    exit();
  }
  
  // Move pedestrians
  pedestrians.movePeople(); 
   
  loopCount++;
}


void keyPressed() {
  if (key == 's') {
     loopCount = STOP_LOOP_COUNT;
  }
}
