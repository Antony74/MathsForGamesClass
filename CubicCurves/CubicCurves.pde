
ArrayList<PVector> p = new ArrayList<PVector>();
float tightness = 0.5;

int drag = 999;
float rect_radius = 10;
float fixedT = 0.5;
float draggedT = -1;
boolean bDragged = false;

static final int mode_bezier = 0;
static final int mode_b = 1;
static final int mode_catmull_rom = 2;

void setup()
{
  size(900, 600);
  rectMode(RADIUS);
  smooth();

  switch(mode)
  {
  case mode_bezier:
    p.add(new PVector(100, 400));
    p.add(new PVector(200,  15));
    p.add(new PVector(200, 550));
    p.add(new PVector(400, 400));

    CubicCurve bezier = new CubicCurve();
    bezier.constructBezier(p.get(0), p.get(1), p.get(2), p.get(3));
    p.add(bezier.getPoint(fixedT));

    break;
  case mode_catmull_rom:
    p.add(new PVector(50, 300));
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
  bDragged = true;  
  
  for (int n = 0; n < p.size(); ++n)
  {
    if (mode == mode_bezier && n == 4)
    {
      break;
    }
    
    PVector v = p.get(n);
    if (abs(mouseX - v.x) <= rect_radius && abs(mouseY - v.y) <= rect_radius)
    {
      drag = n;
      return;
    }
  }

  drag = 999;
  bDragged = false;  
    
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
  if (mode == mode_catmull_rom && drag == 0)
  {
    p.get(drag).y = mouseY;
    tightness = map(mouseY, 200, 400, 0, 1);
  }
  else if (drag < p.size())
  {
    p.get(drag).x = mouseX;
    p.get(drag).y = mouseY;
    
    if (mode == mode_bezier)
    {
      CubicCurve bezier = new CubicCurve();
      bezier.constructBezier(p.get(0), p.get(1), p.get(2), p.get(3));
      p.set(4, bezier.getPoint(fixedT));
    }
  }
  else if (mode == mode_bezier)
  {
    CubicCurve bezier = new CubicCurve();
    bezier.constructBezier(p.get(0), p.get(1), p.get(2), p.get(3));

    if (draggedT == -1)
    {
      draggedT = findT(bezier, pmouseX, pmouseY);
    }
    
    if (draggedT != -1)
    {
      PVector pvMouse = new PVector(mouseX, mouseY);
      
      if (draggedT < fixedT)
      {
        bezier.constructBezier(p.get(0), pvMouse, p.get(4), p.get(3), draggedT, fixedT);
      }
      else
      {
        bezier.constructBezier(p.get(0), p.get(4), pvMouse, p.get(3), fixedT, draggedT);
      }
      
      p.set(0, bezier.getSpecialPoint(0));
      p.set(1, bezier.getSpecialPoint(1));
      p.set(2, bezier.getSpecialPoint(2));
      p.set(3, bezier.getSpecialPoint(3));
    }
  }
  
  drawCurve();

  bDragged = true;  
}

float findT(CubicCurve curve, float x, float y)
{
    float bestt = 0;
    float bestDist = 100000;
  
    for (float t = 0; t <= 1; t+=0.005)
    {
        PVector pt = curve.getPoint(t);
        float hdist = pt.x - x;
        float vdist = pt.y - y;
        float candDist = (hdist * hdist) +(vdist * vdist);
        
        if (bestDist > candDist)
        {
          bestDist = candDist;
          bestt = t;
        }
    }    
  
    if (bestDist < rect_radius && bestt != 0 && bestt != 1)
    {
      return bestt;
    }
    else
    {
      return -1;
    }
}

void mouseReleased()
{
  if (mode == mode_bezier && bDragged == false)
  {
    CubicCurve bezier = new CubicCurve();
    bezier.constructBezier(p.get(0), p.get(1), p.get(2), p.get(3));

    float bestt = findT(bezier, mouseX, mouseY);
  
    if (bestt != -1)
    {
      fixedT = bestt;
      p.set(4, bezier.getPoint(fixedT));
      drawCurve();
    }
  }
  
  draggedT = -1;
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
  
    stroke(0);
    strokeWeight(1);
    line(50, 200, 50, 400);
    line(25, 200, 75, 200);
    line(25, 400, 75, 400);
  
    for (int n = 1; n < p.size() - 3; ++n)
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
  
  for (int n = 0; n < p.size(); ++n)
  {
    if ( (mode == mode_catmull_rom && n == 0)
    ||   (mode == mode_bezier && n == 4) )
    {
      fill(0, 255, 0, 128);
    }
    else
    {
      fill(255, 0, 0, 128);
    }
    
    PVector v = p.get(n);
    rect(v.x, v.y, rect_radius, rect_radius);
  }
}


