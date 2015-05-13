void drawTriangleStrip1_waveform()
{
  pushMatrix(); // use push/popMatrix so each Shape's translation does not affect other drawings
  translate(width/2, height/2); // translate to the right-center
  noStroke();
  beginShape(TRIANGLE_STRIP); // input the shapeMode in the beginShape() call
  texture(images[0]); // set the texture to use
  for (int i=0; i<NUMSEGMENTS+1; i++) {
    int imi = i==NUMSEGMENTS?1:i; // make sure the end equals the start

    // each vertex has a noise-based dynamic movement
    float dynamicInner2 = 1 + noise(fc1+imi); //replace with audio analysis
    float dynamicOuter2 = 0.5 + noise(fc2+imi);

    drawVertex(imi, DIAM_INNER2*dynamicInner2); // draw the vertex using the custom drawVertex() method
    drawVertex(imi, DIAM_OUTER2*dynamicOuter2); // draw the vertex using the custom drawVertex() method
  }
  endShape(); // finalize the Shape
  popMatrix(); // use push/popMatrix so each Shape's translation does not affect other drawings
}

