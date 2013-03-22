
PVector p[] = new PVector[3];
int drag = 999;
float dragt = 999;
float rect_radius = 10;

void setup()
{
  size(900, 600);
  rectMode(RADIUS);

  p[0] = new PVector(100, 400);
  p[1] = new PVector(200,  15);
  p[2] = new PVector(200, 550);

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

  float bestt = 0;
  float bestDist = 100000;

  for (float t = 0; t <= 1; t+=0.002)
  {
      float hdist = quad(p[0].x, p[1].x, p[2].x, t) - mouseX;
      float vdist = quad(p[0].y, p[1].y, p[2].y, t) - mouseY;
      float candDist = (hdist * hdist) +(vdist * vdist);
      
      if (bestDist > candDist)
      {
        bestDist = candDist;
        bestt = t;
      }
  }    

  if (bestDist < rect_radius && bestt != 0 && bestt != 1)
  {
    dragt = bestt;
  }
}

void mouseDragged()
{
  if (drag < p.length)
  {
    p[drag].x = mouseX;
    p[drag].y = mouseY;
    
    drawCurve();
  }
  else if (dragt != 999)
  {
    p[1].x = solve(p[0].x, p[2].x, dragt, mouseX);
    p[1].y = solve(p[0].y, p[2].y, dragt, mouseY);
    
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
  
  quadCurve(
        p[0].x, p[0].y,
        p[1].x, p[1].y,
        p[2].x, p[2].y);

  stroke(0, 0, 128);
  strokeWeight(1);

  noStroke();
  fill(255, 0, 0, 128);
  
  for (int n = 0; n < p.length; ++n)
  {
    PVector v = p[n];
    rect(v.x, v.y, rect_radius, rect_radius);
  }
}

void quadCurve(
        float x1, float y1,
        float xc, float yc,
        float x2, float y2)
{ 
    beginShape();
    for (float t = 0; t <= 1; t+=0.002)
    {
        vertex(quad(x1, xc, x2, t),
               quad(y1, yc, y2, t));
    }    
    endShape();
}

float quad(
        float p1, float c1, float p2,
        float t)
{
    float s = (1 - t);
    float v = 1 * p1 * s * s;
    v      += 2 * c1 * t * s;
    v      += 1 * p2 * t * t;
    return v;
}

float solve(float p1, float p2, float t, float pz)
{
  float s = 1 - t;
  float numerator = pz - (p1 * s * s) - (p2 * t * t);
  float denominator = 2 * t * s;
  return numerator / denominator; 
}


