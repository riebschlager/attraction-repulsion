import toxi.geom.*;
import toxi.physics2d.*;
import toxi.physics2d.behaviors.*;

VerletPhysics2D physics;
ArrayList<Attractor> attractors = new ArrayList<Attractor>();
PImage src;
PGraphics canvas;
Vec2D mousePos;

void setup() {
  canvas = createGraphics(1920, 1080);
  canvas.beginDraw();
  canvas.endDraw();
  size((int) (canvas.width / 2), (int) (canvas.height / 2));
  src = loadImage("http://img-thumb.ffffound.com/static-data/assets/6/55554d68c418080b8248dc858cf4e31c46ec8299_s.jpg");
  src.loadPixels();
  physics = new VerletPhysics2D();
  physics.setDrag(0.75f);
}

void draw() {
  background(0);
  //if (physics.particles.size() < 100) addParticle();
  render();
  image(canvas, 0, 0, width, height);
  for (int i = 0; i < attractors.size(); i++) {
    Attractor a = attractors.get(i);
    a.setStrength(map(noise(a.strengthNoise), 0, 1, -1, 1));
    a.position.x = map(noise(a.xNoise), 0, 1, 0, width);
    a.position.y = map(noise(a.yNoise), 0, 1, 0, height);
    a.strengthNoise += 0.01;
    a.xNoise += 0.0005;
    a.yNoise += 0.0005;
    fill(255);
    ellipse(a.position.x, a.position.y, 5, 5);
  }
}

void addParticle() {
  Particle p = new Particle(width/2, height/2, random(0.5, 1.5));
  Vec2D f = new Vec2D(random(-0.525, 0.525), random(-0.525, 0.525));
  ConstantForceBehavior cb = new ConstantForceBehavior(f);
  p.addBehavior(cb);
  physics.addParticle(p);
  p.pixel1 = src.pixels[floor(random(src.pixels.length - 1))];
  p.pixel2 = src.pixels[floor(random(src.pixels.length - 1000))];
  physics.addBehavior(new AttractionBehavior(p, 50, -0.1f, 0.1f));
}

void addAttractor() {
  Attractor a = new Attractor(new Vec2D(mouseX, mouseY), random(100, 1000), 0, 0);
  physics.addBehavior(a);
  attractors.add(a);
}

void render() {
  canvas.beginDraw();
  canvas.noStroke();
  physics.update();
  for (int i = physics.particles.size() - 1; i > 0; i--) {
    Particle p = (Particle) physics.particles.get(i);
    float x1 = map(p.x, 0, width, 0, canvas.width);
    float y1 = map(p.y, 0, height, 0, canvas.height);
    canvas.fill(lerpColor(p.pixel1,p.pixel2,noise(p.colorNoise)));
    p.radiusNoise += 0.005;
    p.colorNoise += 0.01;
    float r = map(noise(p.radiusNoise), 0, 1, 1, 150);
    canvas.stroke(0, 20);
    canvas.strokeWeight(3);
    canvas.ellipse(x1, y1, r, r);
    //if (y1 < 0 || y1 > canvas.height || x1 < 0 || x1 > canvas.width) physics.removeParticle(p);
  }
  canvas.endDraw();
}

void mousePressed() {
  addAttractor();
}

void keyPressed() {
  if (key == ' ') {
    physics.clear();
    while (physics.particles.size () < 100) addParticle();
  }
  if (key == 's') {
    canvas.save("data/output/composition-" + month() + "-" + day() + "-" + hour() + "-" + minute() + "-" + second() + ".tif");
  }
}

