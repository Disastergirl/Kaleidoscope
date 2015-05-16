abstract class CircularLayer implements Runnable
{
  public final int segmentCount;

  public float innerRadius, outerRadius;

  public PImage currentImage;

  private final float[] xL, yL;

  public CircularLayer(PImage img, int segmentCount, int innerRadius, int outerRadius)
  {
    this.currentImage = img;
    this.segmentCount = segmentCount;
    this.innerRadius = innerRadius;
    this.outerRadius = outerRadius;

    xL = new float[segmentCount];
    yL = new float[segmentCount];
    initAngles();
  }

  private void initAngles()
  {
    float step = TWO_PI / segmentCount; // generate the step size based on the number of segments
    // pre-calculate x and y based on angle and store values in two arrays
    for (int i = 0; i < segmentCount; i++) {
      float theta = step * i; // angle for this segment
      xL[i] = sin(theta);
      yL[i] = cos(theta);
    }
  }

  // custom method that draws a vertex with correct position and texture coordinates
  // based on index and a diameter input parameters
  protected void drawCircleVertex(int index, float diam)
  {
    float x = xL[index] * diam; // pre-calculated x direction times diameter
    float y = yL[index] * diam; // pre-calculated y direction times diameter
    // calculate texture coordinates based on the xy position
    float tx = x / currentImage.width + 0.5;
    float ty = y / currentImage.height + 0.5;
    // draw vertex with the calculated position and texture coordinates
    vertex(x, y, tx, ty);
  }

  protected void drawCircleSegment(int index)
  {
    drawCircleVertex(index, outerRadius);
  }
}
