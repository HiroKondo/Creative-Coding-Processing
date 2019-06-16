class People {
  //Array of the pedestrians
  ArrayList <Pedestrian> pedestrians_;

  // The moving speed of the pedestrian
  float speed_;

  People(float _speed) {
    pedestrians_ = new ArrayList <Pedestrian>();
    speed_ = _speed;
  }

  void setupPeople(int _numberOfPedestrians) {
    for (int i = 0; i < _numberOfPedestrians; i++) {
      pedestrians_.add(new Pedestrian(speed_, true));
    }
  }

  void draw(PGraphics _pg, boolean _people) {
    for (Pedestrian p : pedestrians_) {
      p.draw(_pg, _people);
    }
  }

  void drawPeopleLimitedNum(PGraphics _pg, boolean _people, int _num) {
    if (_num < pedestrians_.size()) {
      for (int i = 0; i < _num; i++) {
        Pedestrian p = pedestrians_.get(i);
        p.draw(_pg, _people);
      }
    } else {
      for (int i = 0; i < pedestrians_.size(); i++) {
        Pedestrian p = pedestrians_.get(i);
        p.draw(_pg, _people);
      }
    }
  }


  void movePeople() {
    for (Pedestrian p : pedestrians_) {
      p.move();
    }
  }
}
