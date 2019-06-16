// Import libraries for HashMap
import java.util.Map;

class CityMap {

  private float mapWidth_ = 100;
  private float mapHeight_ = 100;

  private PVector uppperLeftLatLon_ = new PVector(360, -90);
  private PVector lowerRightLatLon_ = new PVector(-360, 90);

  // The list of the nodes on the map
  private StringList nodesID_;

  // Hashmap to get the x and y coordinate data from the node ID. 
  private HashMap<String, PVector> nodeToPositionMap_;

  // Hashmap to get the adjacent nodes of a node from its ID.
  private HashMap<String, StringList> adjacentNodesMap_;


  public CityMap() {
    nodesID_ = new StringList();
    nodeToPositionMap_  = new HashMap<String, PVector>();
    adjacentNodesMap_  = new HashMap<String, StringList>();
  }


  void setMapSize(float _width, float _height) {
    mapWidth_ = _width;
    mapHeight_ = _height;
  }

  // Import the latitude and longitude data of the nodes from the CSV file.
  // Then, calculate the x and y coordinate on the map 
  void importNodeData(String _nodeDataCSV) {

    println("==============================================");
    println("Start Importing The Nodes' Data on The Map");

    Table dataTable = loadTable(_nodeDataCSV, "header");
    println(dataTable.getRowCount() + " total rows in table"); 
    int i= 0;

    println("The folloing nodes are not inside the map.");
    for (TableRow row : dataTable.rows()) {

      float x = map(row.getFloat("lon"), uppperLeftLatLon_.x, lowerRightLatLon_.x, 0, mapWidth_);
      float y = map(row.getFloat("lat"), uppperLeftLatLon_.y, lowerRightLatLon_.y, 0, mapHeight_);
      nodeToPositionMap_.put(row.getString("id"), new PVector(x, y));

      if (x < 1) {
        println("i = "+ i + ", Place id = "+ row.getString("id") + ", x = " + x + ", y = " + y);
      }
      i++;
    }
    println("Finish Importing The Nodes' Data on The Map");
    println("==============================================");
  }


  // Import the latitude and the longitude data of the corners of the map
  // Then, calculate the x and y coordinate on the map 
  void setMapCornersFromCSV(String _cornerDataCSV) {

    println("==============================================");
    println("Start Importing The Corner Data Data");

    Table dataTable = loadTable(_cornerDataCSV, "header");
    println(dataTable.getRowCount() + " total rows in table"); 
    for (TableRow row : dataTable.rows()) {
      uppperLeftLatLon_.y = row.getFloat("max_lat");
      lowerRightLatLon_.y = row.getFloat("min_lat");
      lowerRightLatLon_.x = row.getFloat("max_lon");
      uppperLeftLatLon_.x = row.getFloat("min_lon");
    }

    println("Finish Importing The Corner Data Data");
    println("UpperLeft = ("+ uppperLeftLatLon_.x + ", "+ uppperLeftLatLon_.y + "), LowerRight = (" + lowerRightLatLon_.x + ", " + lowerRightLatLon_.y + ")");
    println("==============================================");
  }


  // Import the Data about the adjacent nodes of each node
  void importAdjacentNodeData(String _adjacentNodeDataCSV) {

    Table dataTable = loadTable(_adjacentNodeDataCSV);
    println("==============================================");
    println("Start Importing The Data of Adjacent Nodes.");
    println(dataTable.getRowCount() + " total rows in table"); 

    // Read a row of the CSV file
    for (TableRow row : dataTable.rows()) {   
      int columnNum = row.getColumnCount();

      // In the first column, the node ID whose adjacent nodes will be searched is written.
      String id = row.getString(0);

      StringList adjacentNodesList = new StringList();
      // The adjacent nodes IDs are written in the following columns. 
      for (int i=1; i< columnNum; i++) {
        String str = row.getString(i);
        if (str!= null) {
          adjacentNodesList.append(str);
        }
      }

      adjacentNodesMap_.put(id, adjacentNodesList);

      // All of the nodes which have adjacent nodes are added in nodesID_.
      nodesID_.append(id);
    }

    println("Finish Importing The Data of Adjacent Nodes.");
    println("==============================================");
  }
  


  // Get the x and y data of the node
  PVector getNodePosition(String _currentNode) {
    return nodeToPositionMap_.get(_currentNode).copy();
  }


  
}
