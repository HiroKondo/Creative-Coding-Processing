/*
 * Four different patterns of Random Walk.
 *   0. Go to the node which the moving subject has never passed. (Red)
 *   1. Go to the node which the moving subject already passed. (White)
 *   2. Move inside the circle with a certain radius. (Black)
 *   3. Go to as far as possible. (Blue)
 * 
 * The generated images are saved in the folder "frames/[The current time]", ex frames/2019_6_12_23_58/
 * To make a movie, please use other software to make a movie, such as Adobe After Effects.
 *
 * Programmed by Hiroyuki Kondo 
 * 
 * Map data © OpenStreetMap contributors
 *  
 */
 

// Import a library for map.
import java.util.Map;


String cityName = "brooklyn";
String roadType = "limited_20181010";
String nodeDataCSV = cityName + "_" + roadType + "_nodes.csv";
String adjacentNodesDataCSV = cityName + "_" + roadType + "_adjacent_nodes_list.csv";
String nodeAreaCSV = cityName + "_" + roadType + "_area.csv";

String pngFileFolder = "frames/" + year() + "_" + month() + "_" + day() + "_" + hour() + "_" + minute() + "/";

// Class to store the city data
CityMap cityMap = new CityMap();

// Pedestrians information
People pedestrians;

// Number of pedestrians
static int NUMBER_OF_PEDESTRIANS = 30;

// The scale factor to save a big size image
static int SCALE_FACTOR = 2;

// Moving speed
static float MOVING_SPEED = 1 * SCALE_FACTOR;

// The area in which black points moves around
static float MOVING_AREA = 150 * SCALE_FACTOR;

// Background color
color backgroundColor = color(242, 229, 213);


// PGraphics for background color and the locus
PGraphics pgBack;

// PGraphics for circles
PGraphics pgPedestrians;


// Counter for loop
int loopCount = 0;

// Decide how often this program diplays the image on the screen
static int DISPLAY_INTERVAL = 100;

// Decide how often this program savse the image 
static int SAVE_INTERVAL = 100;

// Decide when the program will stop
static int STOP_LOOP_COUNT = 1800;

// Counter for save the frame
int frameCounter = 0;



void setup() {

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

  // Importing the Data about the adjacent nodes of each node
  cityMap.importAdjacentNodeData(adjacentNodesDataCSV);


  // Make moving people
  pedestrians = new People(MOVING_SPEED);
  pedestrians.setupPeople(NUMBER_OF_PEDESTRIANS);

  

  // Setup the nackground
  pgBack = createGraphics(width * SCALE_FACTOR, height * SCALE_FACTOR);
  pgBack.beginDraw();
  pgBack.background(backgroundColor);
  pgBack.endDraw();
}


void draw() {

  // Draw the locus of the moving circles
  // Every 10 loop,draw a rectangle to fade the pattern
  pgBack.beginDraw();
  pgBack.blendMode(BLEND);
  pgBack.smooth();
  if (loopCount % 10 == 0) {
    pgBack.fill(backgroundColor, 10);
    pgBack.noStroke();
    pgBack.rect(0, 0, width * SCALE_FACTOR, height * SCALE_FACTOR);
  }
  pedestrians.draw(pgBack, false);
  pgBack.endDraw();


  // Draw the moving circles
  pgPedestrians  = createGraphics(width * SCALE_FACTOR, height * SCALE_FACTOR);
  pgPedestrians.beginDraw();
  pedestrians.draw(pgPedestrians, true);
  pgPedestrians.endDraw();

  // Combine two PGraphics into one image
  PImage screen = pgBack.get();
  screen.blend(pgPedestrians, 0, 0, width * SCALE_FACTOR, height * SCALE_FACTOR, 0, 0, width * SCALE_FACTOR, height * SCALE_FACTOR, BLEND);

  // This "if" statement is necessary because it takes time to draw the pattern on the screen.
  if (loopCount%DISPLAY_INTERVAL == 0) {
    // Combine two Graphics and show the image on the screen 
    image(screen, 0, 0, width, height);
  }

  // It takes time to save the image and so please do not save the file in every loop .
  if (loopCount%SAVE_INTERVAL == 0) {
    screen.save(pngFileFolder + String.format("%04d", frameCounter) +".png");
    frameCounter++;
  }

  //After the stipulated loops, the program stops.
  if (loopCount >= STOP_LOOP_COUNT) {
    exit();
  } 

  // Move the pedestrians
  pedestrians.movePeople(); 
  println(loopCount + " Loop Done");

  loopCount++;
}


void keyPressed() {
  if (key == 's') {
    exit();
  }
}
