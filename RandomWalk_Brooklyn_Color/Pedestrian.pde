class Pedestrian {
  // The position (x, y)
  PVector position_;

  // The history of the nodes which this pedestrian has passed
  StringList previousNodes_;

  // Next node
  String nextNode_;
  PVector nextNodePoint_;

  // Direction of this pedestrian
  PVector direction_;
  
  // Speed of this pedestrian
  float speed_;

  // Size of the circle 
  float pedestrianSize_ = 7 * SCALE_FACTOR;

  // Size of the circle for trace
  float lineWidth_ = 1.5 * SCALE_FACTOR;

  // Color of Pedestrians
  color pedestrianColor_;
  

  // Moving pattern (0 to 4)
  int movingPatten_;

  Pedestrian(float _initialSpeed, boolean _startFromCenter) {

    String initialNode;
    if (_startFromCenter) {
      //The pedestrian start from the center of the map
      initialNode = cityMap.findCenterNode();
    } else {
      //Choose the start node randomly
      initialNode = cityMap.randomNode();
    }

    // Set the starting node
    position_ = cityMap.getNodePosition(initialNode);
    
    // Initialize the node history
    previousNodes_ = new StringList();

    // Add the initial node to the node history
    nextNode_ = initialNode;

    // Set the next direction
    setNextDirection();

    // Initialize the speed
    speed_ = _initialSpeed;

    // Set moving pattern
    movingPatten_ = 0;

    // Set the color mode
    colorMode(RGB,255,255,255);
    float pattern = random(0,1);
    if(pattern > 0.75){ 
      //Red 
      pedestrianColor_ = color(207, 20, 43);
      movingPatten_ = 0;
    } else if (pattern > 0.5){
      //White
      pedestrianColor_ = color(random(240,255)); 
      movingPatten_ = 1;
    } else if (pattern > 0.25){    
      //Black
      pedestrianColor_ = color(random(0,80));
      movingPatten_ = 2;
    } else {
      //Blue
      pedestrianColor_ = color(33, 77, 157);
      movingPatten_ = 3;
    }
  }

  void decideDirection() {    
    direction_ = PVector.sub(nextNodePoint_,position_);
    direction_.normalize();
  }


  void setNextDirection() {
    // Add current next node to the previous nodes list
    previousNodes_.append(this.nextNode_);
    
    
    // Decide the next node based on the moving pattern    
    switch(movingPatten_) {
      // Pattern 0 : Just try to go to the new node which the moving subject (such as pedestrian, taxis) has never been to.
      case 0:
        nextNode_ = cityMap.searchNextNodeCuriosity(previousNodes_, nextNode_);
        break;
        
      // Pattern 1 : For the first 1200 loop, the pattern is the same as Pattern 0. After that, it goes to the node which the moving subject already passed.
      case 1:
        if (loopCount < 1200) {
          nextNode_ = cityMap.searchNextNodeCuriosity(previousNodes_, nextNode_);
        } else {
          nextNode_ = cityMap.searchNextNodePassed(previousNodes_, nextNode_);
        }
        break;
  
      // Pattern 2 : Move inside the circle with certain radius
      case 2:
        nextNode_ = cityMap.searchNextNodeInLimitedArea(previousNodes_, nextNode_);
        break;
      
      // Pattern 3 : For the first 600 loop, the pattern is the same as Pattern 0. After that, it tries to go to as far as possible.
      case 3:
        if (loopCount < 600) {
          nextNode_ = cityMap.searchNextNodeCuriosity(previousNodes_, nextNode_);
        } else {
          nextNode_ = cityMap.searchNextNodeGoingFurther(previousNodes_, nextNode_);
        }
        break;
  
      default:
        nextNode_ = cityMap.searchNextNodeRandom(previousNodes_, nextNode_);
        break;
    }

    // Get the node data from nodeID
    nextNodePoint_ = cityMap.getNodePosition(nextNode_);
    
    // Set the next node
    decideDirection();
  }


  void move() {
    
    // Move position
    position_.add(PVector.mult(direction_, speed_));
    
    // Check if this pedestrian has passed the destinatio node 
    if (passNode()) {     
      //Set the position of the pedestrian to the destinatio node
      position_ = nextNodePoint_.copy();
      setNextDirection();
    }
  }


  // Check if this pedestrian has passed the destinatio node
  boolean passNode() {
    PVector previousNodePoint = cityMap.getNodePosition(previousNodes_.get(previousNodes_.size()-1));
 
    if (position_.dist(previousNodePoint) >= nextNodePoint_.dist(previousNodePoint)) {
      return true;
    } else {
      return false;
    }
  }

  // Draw the circle on the PGraphic
  void draw(PGraphics _pg, boolean _people) {   
    _pg.fill(pedestrianColor_);
    _pg.noStroke();
    if (_people) {
      _pg.ellipse(position_.x, position_.y, pedestrianSize_, pedestrianSize_);
    } else {
      _pg.ellipse(position_.x, position_.y, lineWidth_, lineWidth_);
    }
  }

  void printData() {
    
    String previousNodeTemp = previousNodes_.get(previousNodes_.size()-1);
    PVector previousNodePoint = cityMap.getNodePosition(previousNodeTemp);
    float distBetweenNodes = nextNodePoint_.dist(previousNodePoint);
    float distFromPreviousNode = position_.dist(previousNodePoint);
    
    println("distBetweenNodes = " + distBetweenNodes + ", distFromPreviousNode = " + distFromPreviousNode);
    println("Previous Node = " + previousNodeTemp + ", Next Node = " + nextNode_ + ", next Node position = " + nextNodePoint_ + ", Current Position = " + position_);
    
  }
}
