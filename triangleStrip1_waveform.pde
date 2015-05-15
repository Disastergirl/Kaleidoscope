void drawTriangleStrip1_waveform()
{
  pushMatrix(); // use push/popMatrix so each Shape's translation does not affect other drawings
  translate(width/2, height/2); // translate to the right-center
  noStroke();
  beginShape(TRIANGLE_STRIP); // input the shapeMode in the beginShape() call
  texture(images[0]); // set the texture to use

  for (int i = 0; i < NUMSEGMENTS + 1; i++)
  {
    int imi = i == NUMSEGMENTS ? 1 : i; // make sure the end equals the start

    // each vertex has a noise-based dynamic movement
    float dynamicOuter2 = pow(fftLog.getAvg(imi), 0.1);

    drawVertex(imi, DIAM_INNER2); // draw the vertex using the custom drawVertex() method
    drawVertex(imi, DIAM_OUTER2 * dynamicOuter2); // draw the vertex using the custom drawVertex() method
  }
  endShape(); // finalize the Shape
  popMatrix(); // use push/popMatrix so each Shape's translation does not affect other drawings
}

