class Particle extends VerletParticle2D {

  int pixel1, pixel2;
  float radiusNoise;
  float colorNoise;

  public Particle(float x, float y, float w) {
    super(x, y, w);
    radiusNoise = random(1000);
    colorNoise = random(1000);
  }
}

