import controlP5.*;

// frame
int border = 50;
int bwidth;
int bheight;

// controls
ControlP5 cp5;
Slider tSlider;
float sliderValue;
float t; // parameter
Button randomisePoints;
CheckBox displayPoints;
Textlabel[][] labels = new Textlabel[2][3];

// points
PVector[] points = new PVector[3];
int pointRadius = 7;
float distance;
float mouseThreshold = 10;
boolean moveable = false;
int draggedPoint;
PVector q, r, p;

void setup() {
  size(1280, 720);
  bwidth = width - border;
  bheight = height - border;
  smooth();
  
  randomisePoints();
  q = new PVector();
  r = new PVector();
  p = new PVector();
  
  // create new ControlP5
  cp5 = new ControlP5(this);
    
  // randomiser button
  randomisePoints = cp5.addButton("randomisePoints")
                       .setValue(0)
                       .setPosition(50, 50)
                       .setSize(200, 20)
                       .setCaptionLabel("Randomise points");
    
  // anchor points checkbox
  displayPoints = cp5.addCheckBox("displayPoints")
                     .setPosition(50, 80)
                     .setSize(20, 20)
                     .setColorLabel(255)
                     .addItem("Display anchor points", 1)
                     .activate(0);
  
  // t parameter slider
  tSlider = cp5.addSlider("sliderValue")
              .setPosition(50, 110)
              .setSize(195, 20)
              .setRange(0, 1)
              .setValue(0.5)
              .setCaptionLabel("t")
              .setColorCaptionLabel(0)
              //.setColorValueLabel(0)
              .setLabelVisible(true);
  sliderValue = 0.5;
  
  // add labels to points
  labels[0][0] = cp5.addTextlabel("A")
                    .setText("A");
  labels[0][1] = cp5.addTextlabel("B")
                    .setText("B");
  labels[0][2] = cp5.addTextlabel("C")
                    .setText("C");
  labels[1][0] = cp5.addTextlabel("Q")
                    .setText("Q");
  labels[1][1] = cp5.addTextlabel("R")
                    .setText("R");
  labels[1][2] = cp5.addTextlabel("P")
                    .setText("P");
}

void draw() {
  // reset
  background(255);
  drawCurve();
  // if checkbox is checked
  if(displayPoints.getState(0)) {
    noFill();
    stroke(0);
    strokeWeight(1);
    // draw lines
    for(int i = 0; i < points.length - 1; i++) {
      line(points[i].x, points[i].y, points[i + 1].x, points[i + 1].y);
    }
    // draw points
    for(int i = 0; i < points.length; i++) {
      ellipse(points[i].x, points[i].y, pointRadius, pointRadius);
    }
    // update t from slider
    t = sliderValue;
    q.x = (1-t) * points[0].x + t * points[1].x;
    q.y = (1-t) * points[0].y + t * points[1].y;
    r.x = (1-t) * points[1].x + t * points[2].x;
    r.y = (1-t) * points[1].y + t * points[2].y;
    // draw first interpolation line
    line(q.x, q.y, r.x, r.y);
    // draw first interpolation points
    noStroke();
    fill(0);
    ellipse(q.x, q.y, pointRadius, pointRadius);
    ellipse(r.x, r.y, pointRadius, pointRadius);
    // draw second interpolation point
    p.x = (1-t) * q.x + t * r.x;
    p.y = (1-t) * q.y + t * r.y;
    fill(#FE4E00);
    ellipse(p.x, p.y, pointRadius * 1.5, pointRadius * 1.5);
    for(int i = 0; i < labels[0].length; i++) {
      labels[0][i].setPosition(points[i].x - 7, points[i].y - 20)
                  .setColorValue(0)
                  .draw(this);
    }
    // change cursor depending on hover
    if(isHover()) {
      cursor(HAND);
    } else {
      cursor(ARROW);
    }
  } else {
    for(int i = 0; i < labels[0].length; i++) {
      labels[0][i].hide();
    }
  }
}

void randomisePoints() {
  for(int i = 0; i < 3; i++) {
    points[i] = new PVector(random(border, bwidth), random(border, bheight));
  }
}

void drawCurve() {
  stroke(255, 204, 0);
  strokeWeight(2);
  for(t = 0; t < 1; t += 0.001) {
    q.x = (1-t) * points[0].x + t * points[1].x;
    q.y = (1-t) * points[0].y + t * points[1].y;
    r.x = (1-t) * points[1].x + t * points[2].x;
    r.y = (1-t) * points[1].y + t * points[2].y;
    p.x = (1-t) * q.x + t * r.x;
    p.y = (1-t) * q.y + t * r.y;
    point(p.x, p.y);
  }
}

boolean isHover() {
  for(int i = 0; i < points.length; i++) {
    if(points[i].x - pointRadius - mouseThreshold < mouseX && mouseX < points[i].x + pointRadius + mouseThreshold
        && points[i].y - pointRadius - mouseThreshold < mouseY && mouseY < points[i].y + pointRadius + mouseThreshold) {
      return true;
    }
  }
  return false;
}

// drag code from https://forum.processing.org/two/discussion/15697/improving-accuracy-of-mousedragged-and-mousereleased-noob-question
void mousePressed() {
  for(int i = 0; i < points.length; i++) {
    distance = dist(mouseX, mouseY, points[i].x, points[i].y);
    if(distance < pointRadius + mouseThreshold) {
      moveable = true;
      draggedPoint = i;
    }
  }
}

void mouseDragged() {
  if(!moveable) {
    return;
  }
  points[draggedPoint].x = mouseX;
  points[draggedPoint].y = mouseY;
}

void mouseReleased() {
  moveable = false;
}