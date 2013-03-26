
ArrayList<PVector> p = new ArrayList<PVector>();
float tightness = 0.5;

int drag = 999;
float rect_radius = 10;

static final int mode_bezier = 0;
static final int mode_b = 1;
static final int mode_catmull_rom = 2;

int mode = mode_bezier;

void setup()
{
  size(900, 600);
  rectMode(RADIUS);

  switch(mode)
  {
  case mode_bezier:
    p.add(new PVector(100, 400));
    p.add(new PVector(200,  15));
    p.add(new PVector(200, 550));
    p.add(new PVector(400, 400));
    break;
  }

  drawCurve();
}

void draw()
{
  // we draw when needed, rather than constantly
}

void mousePressed()
{
  for (int n = 0; n < p.size(); ++n)
  {
    PVector v = p.get(n);
    if (abs(mouseX - v.x) <= rect_radius && abs(mouseY - v.y) <= rect_radius)
    {
      drag = n;
      return;
    }
  }

  drag = 999;
    
  switch(mode)
  {
  case mode_b:
  case mode_catmull_rom:
    p.add(new PVector(mouseX, mouseY));
    break;
  }

  drawCurve();
}

void mouseDragged()
{
  if (drag < p.size())
  {
    p.get(drag).x = mouseX;
    p.get(drag).y = mouseY;
    
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
  noFill();

  ArrayList<CubicCurve> splines = new ArrayList<CubicCurve>();

  switch(mode)
  {
  case mode_catmull_rom:
    for (int n = 0; n < p.size() - 3; ++n)
    {
      CubicCurve spline = new CubicCurve();
      spline.constructCatmullRom(p.get(n), p.get(n + 1), p.get(n + 2), p.get(n + 3), tightness);
      splines.add(spline);
    }
    break;
  case mode_b:
    for (int n = 0; n < p.size() - 3; ++n)
    {
      CubicCurve spline = new CubicCurve();
      spline.constructBSpline(p.get(n), p.get(n + 1), p.get(n + 2), p.get(n + 3), tightness);
      splines.add(spline);
    }
    break;
  case mode_bezier:
  
    CubicCurve bezier = new CubicCurve();
    bezier.constructBezier(p.get(0), p.get(1), p.get(2), p.get(3));
    splines.add(bezier);

    stroke(0, 0, 255);
    strokeWeight(1);

    pv_line(p.get(0), p.get(1));
    pv_line(p.get(2), p.get(3));

    break;
  }

  stroke(0);
  strokeWeight(2);
  
  for (int n = 0; n < splines.size(); ++n)
  {
    CubicCurve c = splines.get(n);

    beginShape();
    for (float t = 0; t <= 1; t+=0.005)
    {
      PVector pt = c.getPoint(t);
      vertex(pt.x, pt.y);
    }
    endShape();
  }
  
  noStroke();
  fill(255, 0, 0, 128);
  
  for (int n = 0; n < p.size(); ++n)
  {
    PVector v = p.get(n);
    rect(v.x, v.y, rect_radius, rect_radius);
  }
}


