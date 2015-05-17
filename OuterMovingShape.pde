class OuterMovingShape extends CircularLayer
{
  float angle = 0;

  OuterMovingShape(PImage img, int segmentCount, int radius)
  {
    super(img, segmentCount, 0, radius);
  }

  void run()
  {
    pushMatrix(); // use push/popMatrix so each Shape's translation does not affect other drawings
    translate(width/2, height/2); // translate to the left-center

    //float level = audioSource.mix.level();
    //float step = level;
    //angle = (angle + step) % TWO_PI;
    //rotate(angle); // rotate around this center

    noStroke(); // turn off stroke
    beginShape(TRIANGLE_FAN); // input the shapeMode in the beginShape() call
    texture(currentImage); // set the texture to use
    vertex(0, 0, 0.5, 0.5); // define a central point for the TRIANGLE_FAN, note the (0.5, 0.5) uv texture coordinates
    for (int i=0; i<segmentCount+1; i++) {
      drawCircleSegment(i % segmentCount); // make sure the end equals the start & draw the vertex using the custom drawVertex() method
    }
    endShape(); // finalize the Shape
    popMatrix(); // use push/popMatrix so each Shape's translation does not affect other drawings
  }
}
