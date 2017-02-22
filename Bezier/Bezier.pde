void setup()
{
    size(500, 650);
    strokeWeight(3);
    background(255);
    noFill();

    quadCurve(
          100, 200,
          150, -150,
          400, 200);
    
    stroke(255,0,0);

    cubicCurve(
          100,  400,
          200,    0,
          200,  550,
          400,  400);

    stroke(0,255,0);

    quarticCurve(
          100,  600,
          200,    0,
          200,  900,
          300,  300,
          400,  600);
}

void draw()
{

}

void quadCurve(
        float x1, float y1,
        float xc, float yc,
        float x2, float y2)
{ 
    for (float t = 0; t <= 1; t+=0.002)
    {
        ellipse(quad(x1, xc, x2, t),
                quad(y1, yc, y2, t),
                5,5);
    }    
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

void cubicCurve(
        float x1,  float y1,
        float xc1, float yc1,
        float xc2, float yc2,
        float x2,  float y2)
{
    for (float t = 0; t <= 1; t+=0.002)
    {
        ellipse(cubic(x1, xc1, xc2, x2, t),
                cubic(y1, yc1, yc2, y2, t),
                5,5);
    }    
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

void quarticCurve(
        float x1,  float y1,
        float xc1, float yc1,
        float xc2, float yc2,
        float xc3, float yc3,
        float x2,  float y2)
{
    for (float t = 0; t <= 1; t+=0.002)
    {
        ellipse(quartic(x1, xc1, xc2, xc3, x2, t),
                quartic(y1, yc1, yc2, yc3, y2, t),
                5,5);
    }    
}

float quartic(float p1,
              float c1, float c2, float c3,
              float p2,
              float t)
{
  float s = (1 - t);
  float v = 1 * p1 * s * s * s * s;
  v      += 4 * c1 * s * s * s * t;
  v      += 6 * c2 * s * s * t * t;
  v      += 4 * c3 * s * t * t * t;
  v      += 1 * p2 * t * t * t * t;
  return v;
}


