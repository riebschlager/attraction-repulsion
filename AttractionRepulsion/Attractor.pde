class Attractor extends AttractionBehavior {

  Vec2D position;
  float xNoise, yNoise, strengthNoise;
  int behavior;

  public Attractor(Vec2D _position, float _radius, float _strength, float _jitter, int _behavior) {
    super(_position, _radius, _strength, _jitter);
    position = _position;
    xNoise = random(1000);
    yNoise = random(1000);
    strengthNoise = random(1000);
    behavior = _behavior;
  }
}

