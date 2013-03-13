
PVector p[] = new PVector[4];
int drag = 999;
float rect_radius = 10;

void setup()
{
  size(900, 600);
  rectMode(RADIUS);

  p[0] = new PVector(100, 400);
  p[1] = new PVector(200,  15);
  p[2] = new PVector(200, 550);
  p[3] = new PVector(400, 400);

  drawCurve();
}

void draw()
{
  // we draw when needed, rather than constantly
}

void mousePressed()
{
  for (int n = 0; n < p.length; ++n)
  {
    PVector v = p[n];
    if (abs(mouseX - v.x) <= rect_radius && abs(mouseY - v.y) <= rect_radius)
    {
      drag = n;
      return;
    }
  }
  
  drag = 999;
}

void mouseDragged()
{
  if (drag < p.length)
  {
    p[drag].x = mouseX;
    p[drag].y = mouseY;
    
    drawCurve();
  }
}

void pv_line(PVector a, PVector b)
{
  line(a.x, a.y, b.x, b.y);
}

void drawCurve()
{
  background(128);
  stroke(0);
  strokeWeight(2);
  noFill();
  
  cubicCurve(
        p[0].x, p[0].y,
        p[1].x, p[1].y,
        p[2].x, p[2].y,
        p[3].x, p[3].y);

  stroke(0, 0, 128);
  strokeWeight(1);
  pv_line( p[0], p[1]);
  pv_line( p[2], p[3]);

  noStroke();
  fill(255, 0, 0, 128);
  
  for (int n = 0; n < p.length; ++n)
  {
    PVector v = p[n];
    rect(v.x, v.y, rect_radius, rect_radius);
  }
}

void cubicCurve(
        float x1,  float y1,
        float xc1, float yc1,
        float xc2, float yc2,
        float x2,  float y2)
{
  beginShape();
  for (float t = 0; t <= 1; t+=0.002)
  {
    vertex(cubic(x1, xc1, xc2, x2, t),
           cubic(y1, yc1, yc2, y2, t));
  }    
  endShape();
}

float cubic(float p1, float c1,
            float c2,  float p2,
            float t)
{
    float s = (1 - t);
    float v = 1 * p1 * s * s * s;
    v      += 3 * c1 * s * s * t;
    v      += 3 * c2 * s * t * t;
    v      += 1 * p2 * t * t * t;
    return v;        
}


