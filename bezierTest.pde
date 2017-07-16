import controlP5.*;

ControlP5 cp5;
float t = 0;
float sliderValue = 0;
Slider slider;

PVector[] points = {
  new PVector(100, 100),
  new PVector(400, 300),
  new PVector(700, 100)
};

PVector q, r, p;
ArrayList<PVector> curve;

void setup() {
  size(1280, 720);
  //background(51);
  //stroke(255);
  //fill(255);
  smooth();
  //noLoop();
  
  // horizontal slider
  cp5 = new ControlP5(this);
  cp5.addSlider("sliderValue")
    .setPosition(100, 50)
    .setSize(200, 20)
    .setRange(0, 1);
}

// degree of polynomial
int degree = points.length - 1;

void drawCurve() {
  q = new PVector();
  r = new PVector();
  p = new PVector();
  stroke(255, 204, 0);
  strokeWeight(2);
  for(t = sliderValue; t < 1; t += 0.001) {
    q.x = (1-t) * points[0].x + t * points[1].x;
    q.y = (1-t) * points[0].y + t * points[1].y;
    r.x = (1-t) * points[1].x + t * points[2].x;
    r.y = (1-t) * points[1].y + t * points[2].y;
    p.x = (1-t) * q.x + t * r.x;
    p.y = (1-t) * q.y + t * r.y;
    point(p.x, p.y);
    line(q.x, q.y, r.x, r.y);
  }
}

void draw() {
  // reset
  background(255);
  // line through control points
  stroke(0);
  strokeWeight(1);
  for(int i = 0; i < degree; i++) {
    line(points[i].x, points[i].y, points[i + 1].x, points[i + 1].y);
  }
  // update t from slider
  //t = sliderValue;
  // weighted average points
  //line(q.x, q.y, r.x, r.y);
  drawCurve();
}