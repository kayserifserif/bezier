import controlP5.*;

// VARIABLES

int border = 50;
int bwidth;
int bheight;

ControlP5 cp5;
Slider tSlider;
float sliderValue;
Button randomisePoints;
CheckBox displayPoints;

PVector[] points = new PVector[3];
int pointRadius = 7;

PVector q, r, p;

float t = 0;

void randomisePoints() {
  for(int i = 0; i < 3; i++) {
    points[i] = new PVector(random(border, bwidth), random(border, bheight));
  }
}

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
    
  // control points checkbox
  displayPoints = cp5.addCheckBox("displayPoints")
                     .setPosition(50, 80)
                     .setSize(20, 20)
                     .setColorLabel(255)
                     .addItem("Display control points", 1)
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

// hover
void checkMouseHover() {
  for(int i = 0; i < points.length; i++) {
    if(points[i].x - pointRadius < mouseX && mouseX < points[i].x + pointRadius
        && points[i].y - pointRadius < mouseY && mouseY < points[i].y + pointRadius) {
      cursor(HAND);      
    }
    else {
      cursor(ARROW);
    }
  }
}

// drag control points
void mouseDragged() {
  for(int i = 0; i < points.length; i++) {
    if(points[i].x - pointRadius < mouseX && mouseX < points[i].x + pointRadius
        && points[i].y - pointRadius < mouseY && mouseY < points[i].y + pointRadius) {
      points[i].x = mouseX;
      points[i].y = mouseY;
    }
  }
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
    for(int i = 0; i < points.length - 1; i++) {
      line(points[i].x, points[i].y, points[i + 1].x, points[i + 1].y);
    }
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
    //fill(#72A276);
    fill(#FE4E00);
    ellipse(p.x, p.y, pointRadius * 1.5, pointRadius * 1.5);
    checkMouseHover();
  }
}