
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

  Cubic c = new Cubic();
  c.constructBezier(p[0], p[1], p[2], p[3]);  

  beginShape();
  for (float t = 0; t <= 1; t+=0.002)
  {
    PVector pt = c.getPoint(t);
    vertex(pt.x, pt.y);
  }
  endShape();
  
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


