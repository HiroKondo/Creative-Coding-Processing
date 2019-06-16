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
  float pedestrianSize_ = 3 * SCALE_FACTOR;

  // Size of the circle for trace
  float lineWidth_ = 1.5 * SCALE_FACTOR;

  // Color of Pedestrians
  color pedestrianColor_;
  float hue_;
  float saturation_;
  float brightness_;
  float alpha_;
  

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
    colorMode(HSB, 360, 100, 100, 100);
    hue_ = random(360);
    saturation_ = random(0, 30);
    brightness_ = 100;
    alpha_ = 0;
    pedestrianColor_ = color(hue_, saturation_, this.brightness_, this.alpha_);
  }

  void decideDirection() {    
    direction_ = PVector.sub(nextNodePoint_,position_);
    direction_.normalize();
  }


  void setNextDirection() {
    // Add current next node to the previous nodes list
    previousNodes_.append(nextNode_);
       
    // Decide the next node randomly
    nextNode_ = cityMap.searchNextNodeRandom(previousNodes_, nextNode_);

    // Get the node data from nodeID
    nextNodePoint_ = cityMap.getNodePosition(nextNode_);
    
    //Set the next node
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
    colorMode(HSB, 360, 100, 100, 100);
    pedestrianColor_ = color(hue_, saturation_, brightness_, alpha_);
    alpha_ += 3;
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
