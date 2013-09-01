import toxi.geom.*;
import toxi.physics2d.*;
import toxi.physics2d.behaviors.*;

VerletPhysics2D physics;
ArrayList<Attractor> attractors = new ArrayList<Attractor>();
PImage src;
PGraphics canvas;
PImage background;
Vec2D mousePos;

void setup() {
  canvas = createGraphics(1920, 1080);
  canvas.beginDraw();
  canvas.endDraw();
  size(floor(canvas.width / 2), floor(canvas.height / 2));
  background = loadImage("data/img/background.png");
  if (background.width != width || background.height != height) background.resize(width, height);
  src = loadImage("http://img.ffffound.com/static-data/assets/6/d00fb8ad1b4164cc78474c4cd1726d92e9c3aad5_m.jpg");
  src.loadPixels();
  physics = new VerletPhysics2D();
  physics.setDrag(0.75f);
}

void draw() {
  background(background);
  render();
  image(canvas, 0, 0, width, height);
  for (int i = 0; i < attractors.size(); i++) {
    Attractor a = attractors.get(i);
    if (a.behavior == 1) a.setStrength(map(noise(a.strengthNoise), 0, 1, 0, 2));
    if (a.behavior == -1) a.setStrength(map(noise(a.strengthNoise), 0, 1, -2, 0));
    a.position.x = map(noise(a.xNoise), 0, 1, 0, width);
    a.position.y = map(noise(a.yNoise), 0, 1, 0, height);
    a.strengthNoise += 0.005;
    a.xNoise += 0.0025;
    a.yNoise += 0.0025;
    if (a.behavior == 1) fill(0, 200, 0);
    if (a.behavior == -1) fill(200, 0, 0);
    strokeWeight(0.5);
    ellipse(a.position.x, a.position.y, 5, 5);
  }
  //saveFrameForVideo();
}

void addParticle() {
  Particle p = new Particle(random(width), random(height), random(0.5, 1.5), random(5, 200));
  Vec2D f = new Vec2D(random(-0.525, 0.525), random(-0.525, 0.525));
  ConstantForceBehavior cb = new ConstantForceBehavior(f);
  p.addBehavior(cb);
  physics.addParticle(p);
  p.pixel1 = src.pixels[floor(random(src.pixels.length - 1))];
  p.pixel2 = src.pixels[floor(random(src.pixels.length - 1))];
  physics.addBehavior(new AttractionBehavior(p, 50, -1f));
}

void addAttractor(int _behavior) {
  Attractor a = new Attractor(new Vec2D(mouseX, mouseY), width / 3, 0, 0, _behavior);
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
    canvas.fill(lerpColor(p.pixel1, p.pixel2, noise(p.colorNoise)));
    p.radiusNoise += 0.005;
    p.colorNoise += 0.0075;
    float r = map(noise(p.radiusNoise), 0, 1, p.maxRadius/20, p.maxRadius);
    canvas.stroke(0, 20);
    canvas.strokeWeight(1);
    canvas.ellipse(x1, y1, r, r);
    //if (y1 < 0 || y1 > canvas.height || x1 < 0 || x1 > canvas.width) physics.removeParticle(p);
  }
  canvas.endDraw();
}

void saveFrameForVideo() {
  String fileName = nf(frameCount, 5) + ".tif";
  saveFrame("data/video/" + fileName);
}

void keyPressed() {
  if (key == 'a' || key == 'A') addAttractor(1);
  if (key == 'r' || key == 'R') addAttractor(-1);
  if (key == 'c' || key == 'C') {
    canvas.beginDraw();
    canvas.clear();
    canvas.endDraw();
    physics.clear();
    attractors.clear();
  }
  if (key == ' ') attractors.clear();
  if (key == 'q') physics.clear();
  if (key == 'p' || key == 'P') for (int i = 0; i < 50; i++) addParticle();
  if (key == 's' || key == 'S') {
    PGraphics img = createGraphics(canvas.width, canvas.height);
    img.beginDraw();
    img.image(background, 0, 0, canvas.width, canvas.height);
    img.image(canvas, 0, 0);
    img.endDraw();
    img.save("data/output/composition-" + month() + "-" + day() + "-" + hour() + "-" + minute() + "-" + second() + ".tif");
  }
}

