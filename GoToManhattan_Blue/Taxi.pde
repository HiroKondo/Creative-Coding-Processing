class Taxi {
  // The position (x, y)
  private PVector position_;

  // The history of the nodes which this pedestrian has passed
  private StringList routeNodes_;

  // The ID ofthe next node
  private int nextNodeNum_;

  // x and y cooridnate of the next node
  private PVector nextNodePoint_;

  // Direction of this pedestrian
  private PVector direction_;
  
  // Speed of this pedestrian
  private float speed_;

  // Size of the circle for trace
  private float coreSize_ = 1 * SCALE_FACTOR;


  private boolean running_ = true;
  
   

  Taxi(float _initialSpeed, StringList _routeNodes) {

    routeNodes_ = new StringList(_routeNodes);

    //Set the starting node position
    position_  = cityMap.getNodePosition(routeNodes_.get(0));

    //Add the initial node to the node history
    nextNodeNum_ = 0;

    //Set the next direction
    setNextDirection();    

    speed_ = _initialSpeed;

  }

  void decideDirection() {    
    direction_ = PVector.sub(nextNodePoint_,position_);
    direction_.normalize();
  }


  void setNextDirection() {
    nextNodeNum_+=1;

    //Get the information of the next node from the map
    if (nextNodeNum_ < routeNodes_.size()) {
      nextNodePoint_ = cityMap.getNodePosition(routeNodes_.get(nextNodeNum_));
      //Set the next node
      decideDirection();
    } else {
      running_ = false;
    }
  }


  void move() {
    if (running_) {  
      position_.add(PVector.mult(direction_, speed_));      
      //Check if this pedestrian has passed the destinatio node
      if (passNode()) {
        //Set the position of the pedestrian to the destinatio node
        position_ = nextNodePoint_.copy();
        setNextDirection();
      }
    }
  }


  //Check if this pedestrian has passed the destinatio node
  boolean passNode() {
    PVector previousNodePoint = cityMap.getNodePosition(routeNodes_.get(nextNodeNum_-1));
    float distBetweenNodes = nextNodePoint_.dist(previousNodePoint);
    float distFromPreviousNode = position_.dist(previousNodePoint);

    if (distFromPreviousNode >= distBetweenNodes ) {
      return true;
    } else {
      return false;
    }
  }

  boolean isRunning(){
    return running_;
  }

  void draw(PGraphics _pg) {
      _pg.fill(61, 160, 155, 5);
      _pg.ellipse(position_.x,position_.y,coreSize_* 1.5,coreSize_* 1.5);
  }

  void printData() {
    
    String previousNodeTemp = routeNodes_.get(nextNodeNum_-1);
    PVector previousNodePoint = cityMap.getNodePosition(previousNodeTemp);
    float distBetweenNodes = nextNodePoint_.dist(previousNodePoint);
    float distFromPreviousNode = this.position_.dist(previousNodePoint);
    
    println("distBetweenNodes = " + distBetweenNodes + ", distFromPreviousNode = " + distFromPreviousNode);
    println("Previous Node = " + previousNodeTemp + ", previous  Node position = " + previousNodePoint + ", Next Node = " + routeNodes_.get(nextNodeNum_) + ", next Node position = " + nextNodePoint_ + ", Current Position = " + this.position_);
    
  }
  
  void printRoute(){
    println("ROUTE");
    println(routeNodes_);
  }
  
}
