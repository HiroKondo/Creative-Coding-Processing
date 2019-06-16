/*
 * The program to make a colorful map of Brooklyn.
 *
 * Programmed by Hiroyuki Kondo 
 *
 * Map data © OpenStreetMap contributors
 *
 */


//import a library for map.
import java.util.Map;


String cityName = "brooklyn";
String roadType = "car_road";
String nodeDataCSV = cityName + "_" + roadType + "_nodes.csv";
String adjacentNodesDataCSV = cityName + "_" + roadType + "_adjacent_nodes_list.csv";
String nodeAreaCSV = cityName + "_" + roadType + "_area.csv";


// Class to store the city data
CityMap cityMap = new CityMap();


// Scale factor to save a big size image
static int SCALE_FACTOR = 4;


// Background color
color grayBackgroundColor = color(26);

// PGraphics for the colorful background
PGraphics pgBack;

// PGraphics for roads
PGraphics pgRoads;

// PGraphics for gray background
PGraphics pgGrayBackground;


void setup() {
  
  // Setup the window
  background(grayBackgroundColor);
  size(1000, 1000); 
  smooth();
  
  // Set the size of the map.
  // This funstion must be called at the beginning. 
  cityMap.setMapSize(width * SCALE_FACTOR, height * SCALE_FACTOR);


  // Import the latitude and the longitude data of the corners of the map
  cityMap.setMapCornersFromCSV(nodeAreaCSV);

  // Import the the latitude and longitude data of the nodes in the map.
  // Then, calculating the x and y coordinate on the map
  // This function must be done after the function "setMapCornersFromCSV" because this function use the corner data
  cityMap.importNodeData(nodeDataCSV, SCALE_FACTOR);

  // Import the Data about the adjacent nodes of each node
  cityMap.importAdjacentNodeData(adjacentNodesDataCSV);


  // This PGraphics is the background of the window. 
  // Create the PGraphics and paint in the dark gray color.
  pgGrayBackground = createGraphics(width * SCALE_FACTOR, height * SCALE_FACTOR);
  pgGrayBackground.beginDraw();
  pgGrayBackground.background(grayBackgroundColor);
  pgGrayBackground.endDraw();



  // This PGraphics is masked with pgRoads.
  // Create the PGraphics then paint it with a color gradation from the top to the bottom
  pgBack = createGraphics(width * SCALE_FACTOR, height * SCALE_FACTOR);
  pgBack.beginDraw();
  pgBack.blendMode(BLEND);
  pgBack.smooth();
  for (int i= 0; i < height * SCALE_FACTOR; i ++) {
    pgBack.colorMode(HSB, 360, 100, 100, 100);
    float hue = map(i, 0, height * SCALE_FACTOR, 0, 360);
    pgBack.stroke(hue, 50, 100);
    pgBack.line(0, i, width * SCALE_FACTOR, i);
  }
  pgBack.endDraw();


  // This PGraphics is used with pgBack.
  // Create the PGraphics and draw lines of the roads with white. 
  // To mask the pgBack correctly, the background must be black, and the line must be white.
  pgRoads = createGraphics(width * SCALE_FACTOR, height * SCALE_FACTOR);
  pgRoads.beginDraw();
  pgRoads.background(0);
  cityMap.drawLines(pgRoads, color(255), 1);
  pgRoads.endDraw();


  // Masking
  pgBack.mask(pgRoads);


  // Combine the colorful roads' graphic with the gray background.
  pgGrayBackground.blend(pgBack, 0, 0, width * SCALE_FACTOR, height * SCALE_FACTOR, 0, 0, width * SCALE_FACTOR, height * SCALE_FACTOR, BLEND);

  // Draw the final image on the screen.
  image(pgGrayBackground, 0, 0, width, height);


  // Save the image in a small size (1000 * 1000).
  save("frames/" + "Brooklyn_Color_Gradation_normal_" + year() + "_" + month() + "_" + day() + "_" + hour() + "_" + minute() + ".png");  
  
  // Save the image in a large size (4000 * 4000).
  pgGrayBackground.save("frames/" + "Brooklyn_Color_Gradation_hi-res_" + year() + "_" + month() + "_" + day() + "_" + hour() + "_" + minute() + ".png");
}


void draw() {

  // The unit is milliseconds.
  // The following two functions are necessary to show the final result on the screen.
  // After the spiculated amount of the time, the program will quit.
  delay(10 * 1000);
  exit();
}
