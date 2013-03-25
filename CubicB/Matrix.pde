
class Matrix
{
  float m[][];

  Matrix()
  {
  }

  Matrix(int nWidth, int nHeight)
  {
    m = new float[nWidth][nHeight];
  }

  //
  // Convenience methods for constructing matrices of the sizes needed
  //

  void construct4x1(float m00, float m10, float m20, float m30)
  {
    m = new float[4][1];
    m[0][0] = m00;    m[1][0] = m10;    m[2][0] = m20;    m[3][0] = m30;
  }
  
  void construct1x4(float m00,
                    float m01,
                    float m02,
                    float m03)
  {
    m = new float[1][4];
    m[0][0] = m00;
    m[0][1] = m01;
    m[0][2] = m02;
    m[0][3] = m03;
  }

  void construct3x2(float m00, float m10, float m20,
                    float m01, float m11, float m21)
  {
    m = new float[3][2];
    m[0][0] = m00;    m[1][0] = m10;    m[2][0] = m20;
    m[0][1] = m01;    m[1][1] = m11;    m[2][1] = m21;
  }

  void construct4x4(float m00, float m10, float m20, float m30,
                    float m01, float m11, float m21, float m31,
                    float m02, float m12, float m22, float m32,
                    float m03, float m13, float m23, float m33)
  {
    m = new float[4][4];
    m[0][0] = m00;    m[1][0] = m10;    m[2][0] = m20;    m[3][0] = m30;
    m[0][1] = m01;    m[1][1] = m11;    m[2][1] = m21;    m[3][1] = m31;
    m[0][2] = m02;    m[1][2] = m12;    m[2][2] = m22;    m[3][2] = m32;
    m[0][3] = m03;    m[1][3] = m13;    m[2][3] = m23;    m[3][3] = m33;
  }

  //
  // Gaussian elimination
  //

  void eliminate()
  {
    if (m.length < m[0].length)
    {
      throw new RuntimeException("Matrix is longer than it is wide");
    }
    
    for (int nRank = 0; nRank < m[0].length; ++nRank)
    {
      if (m[nRank][nRank] == 0)
      {
        int nRow = findNonZeroRow(nRank);
        addRows(nRow, nRank, 1);
      }
      
      divideRow(nRank, m[nRank][nRank]);
      
      for (int nRow = 0; nRow < m[0].length; ++nRow)
      {
        if (nRow != nRank)
        {
          addRows(nRank, nRow, -m[nRank][nRow]);
        }
      }
    }
  }
  
  void addRows(int nSource, int nDest, float multiple)
  {
    for (int nCol = 0; nCol < m.length; ++nCol)
    {
      float value = m[nCol][nSource];
      value *= multiple;
      m[nCol][nDest] += value;
    }
  }

  void divideRow(int nRow, float denominator)
  {
    for (int nCol = 0; nCol < m.length; ++nCol)
    {
      m[nCol][nRow] /= denominator;
    }
  }
  
  void divideMatrix(float denominator)
  {
    for (int nRow = 0; nRow < m.length; ++nRow)
    {
      divideRow(nRow, denominator);
    }
  }
  
  int findNonZeroRow(int nCol)
  {
    for (int nRow = 0; nRow < m[0].length; ++nRow)
    {
      if (m[nCol][nRow] != 0)
      {
        return nRow;
      }
    }
    
    throw new RuntimeException("No solution");
  }
  
  //
  // Some drawing code for debuging matrix calculations
  //

  float m_textSize = 11;

  String cell(int x, int y)
  {
    String s = str(m[x][y]);

    if (s.length() > 5) 
      return s.substring(0,5);
    else
      return s;
  }

  float calculateColumnWidth()
  {
    float colWidth = 0;
    
    for (int x = 0; x < m.length; ++x)
    {
      for (int y = 0; y < m[0].length; ++y)
      {
        float colWidth2 = textWidth(cell(x,y));
        colWidth = max(colWidth, colWidth2);
      }
    }
    
    return colWidth;
  }
  
  void drawBracket(String s)
  {
    textSize(m_textSize * m[0].length);
    text(s, -textWidth(s)/2, 0);
    translate(textWidth(s), 0);
    textSize(m_textSize);
  }
  
  void draw()
  {
    translate(m_textSize, 0);

    float colWidth = calculateColumnWidth() * 1.5;
    float vCentre = (m_textSize * m[0].length * 1.5) / 2;

    drawBracket("(");
    
    for (int x = 0; x < m.length; ++x)
    {
      for (int y = 0; y < m[0].length; ++y)
      {
        text(cell(x,y), colWidth * x, (m_textSize * y * 1.5) - vCentre);
      }
    }
    
    translate(colWidth * m.length, 0);

    drawBracket(")");

    translate(m_textSize, 0);
  }

  void drawText(String s)
  { 
    text(s, 0, -m_textSize/2);
    translate(textWidth(s), 0);
  }
}

//
// Matrix multipication
//
Matrix multiply(Matrix A, Matrix B)
{
  if (A.m.length != B.m[0].length)
  {
    throw new RuntimeException(
                       "Not compatible");
  }

  Matrix C = new Matrix(B.m.length, A.m[0].length);
  
  for (int x = 0; x < C.m.length; ++x)
  {
    for (int y = 0; y < C.m[0].length; ++y)
    {
      float value = 0;
      
      for (int z = 0; z < A.m.length; ++z)
      {
        value += A.m[z][y] * B.m[x][z];
      }
      
      C.m[x][y] = value;
    }
  }
  
  return C;
}

