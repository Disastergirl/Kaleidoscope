void drawTriangleStrip2_spectro()
{
  pushMatrix(); // use push/popMatrix so each Shape's translation does not affect other drawings
  translate(width/2, height/2); // translate to the right-center
  noStroke();
  stroke(255); // set stroke to white
  beginShape(TRIANGLE_STRIP); // input the shapeMode in the beginShape() call
  texture(images[3]); // set the texture to use
  for (int i=0; i<NUMSEGMENTS+1; i++) {
    int im = i==NUMSEGMENTS?0:i; // make sure the end equals the start

    // each vertex has a noise-based dynamic movement
    float dynamicInner = 0.5 + noise(fc1+im); //replace with audio analysis
    float dynamicOuter = 0.5 + noise(fc2+im);

    drawVertex(im, DIAM_INNER*dynamicInner); // draw the vertex using the custom drawVertex() method
    drawVertex(im, DIAM_OUTER*dynamicOuter); // draw the vertex using the custom drawVertex() method
  }
  endShape(); // finalize the Shape
  popMatrix(); // use push/popMatrix so each Shape's translation does not affect other drawings
}

