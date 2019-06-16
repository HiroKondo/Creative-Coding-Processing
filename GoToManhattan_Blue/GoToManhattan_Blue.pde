/*
 * This program visualizes the 10000 circles which move from various places in New York to a place in Manhattan.
 * I calculated the route for each circle using python.
 * 
 * This program is written to make a movie.
 * The generated images are saved in the folder "frames/[The current time]", ex frames/2019_6_12_23_58/
 * Please use other software to make a movie, such as Adobe After Effects.
 *
 * This program is heavy. So, if you just want to check the output, set SAVE_INTERVAL to 1000 and change the SCALE_FACTOR to 1. 
 *
 * I was inspired by "Attractor 0" by Masaki Yamabe (http://www.openprocessing.org/sketch/394718).
 *
 * Programmed by Hiroyuki Kondo 
 * 
 * Map data © OpenStreetMap contributors
 *  
 */


//import a library for map.
import java.util.Map;

String cityName = "brooklyn_car_road_20190122";
String nodeDataCSV = cityName + "_nodes.csv";
String adjacentNodesDataCSV = cityName + "_adjacent_nodes_list.csv";
String nodeAreaCSV = cityName + "_area.csv";

String routeDataCSV = "route_For_Draw.csv";

String pngFileFolder = "frames/" + year() + "_" + month() + "_" + day() + "_" + hour() + "_" + minute() + "/";


// Class to store the city data
CityMap cityMap = new CityMap();


ArrayList <Taxi> taxis = new ArrayList<Taxi>();

// The scale factor to save a big size image
static int SCALE_FACTOR = 2;

// Moving speed
static float MOVING_SPEED = 0.4 * SCALE_FACTOR;


// background color
color backgroundColor = color(0, 0, 0);

// PGraphics to draw patterns
PGraphics pgDrawing;

//counter for loop
int loopCount = 0;

// Decide how often this program diplays the image on the screen
static int DISPLAY_INTERVAL = 1;

// Decide how often this program savse the image 
static int SAVE_INTERVAL = 10;


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
  // Then, calculating the x and y coordinate on the map
  // This function must be done after the function "setMapCornersFromCSV" because this function use the corner data
  cityMap.importNodeData(nodeDataCSV);

  // Import the Data about the adjacent nodes of each node
  cityMap.importAdjacentNodeData(adjacentNodesDataCSV);

  
  // Import route data.
  importRouteData();
  
  // Create graphics
  pgDrawing = createGraphics(width * SCALE_FACTOR, height * SCALE_FACTOR);
  pgDrawing.beginDraw();
  pgDrawing.background(backgroundColor);
  pgDrawing.endDraw();
  
}


void draw() {
  
  pgDrawing.beginDraw();
  pgDrawing.blendMode(ADD);
  pgDrawing.fill(0);
  pgDrawing.rect(0,0,width * SCALE_FACTOR, height * SCALE_FACTOR);


  boolean allVacant = true;
  
  for (Taxi taxiDraw : taxis) {
    taxiDraw.draw(pgDrawing);
    taxiDraw.move();
    if (taxiDraw.isRunning()) {
      allVacant = false;
    }
  }
  pgDrawing.endDraw();
   
   
  if(loopCount%DISPLAY_INTERVAL == 0){
    image(pgDrawing,0, 0, width, height);    
  }
  
  if(loopCount%SAVE_INTERVAL == 0){
    pgDrawing.save(pngFileFolder + "Final_" + String.format("%06d",loopCount) + ".png");    
  }
  
  if(allVacant){
    pgDrawing.save(pngFileFolder + "Final_" + String.format("%06d",loopCount) + ".png");
    exit();
  }
  
  println("Frame : " + loopCount + ", FrameRate = " + frameRate);
  loopCount++;
}


void importRouteData() {

  Table dataTable = loadTable(routeDataCSV);
  println(dataTable.getRowCount() + " total rows in table"); 

  for (TableRow row : dataTable.rows()) {   
    int column_num = row.getColumnCount();    
    StringList routeTemp = new StringList();
    for (int i = 0; i < column_num; i++) {
      String nodeTemp = row.getString(i);
      if (nodeTemp!= null) {
        routeTemp.append(nodeTemp);
      }
    }
    taxis.add(new Taxi(MOVING_SPEED, routeTemp));
  }
}


void keyPressed() {
  if (key == 's') {
    exit();
  }
}
