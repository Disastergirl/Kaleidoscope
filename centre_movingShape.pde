void drawCentreMovingShape()
{
  pushMatrix(); // use push/popMatrix so each Shape's translation does not affect other drawings
  translate(width/2, height/2); // translate to the left-center
  rotate(frameCount*-0.002); // rotate around this center --anticlockwise
  noStroke(); // turn off stroke
  beginShape(TRIANGLE_FAN); // input the shapeMode in the beginShape() call
  texture(images[currentImage2]); // set the texture to use
  vertex(10, 10, 0.5, 0.5); // define a central point for the TRIANGLE_FAN, note the (0.5, 0.5) uv texture coordinates
  for (int i=0; i<NUMSEGMENTS+1; i++) {
    drawVertex(i==NUMSEGMENTS?0:i, DIAM2_FIXED); // make sure the end equals the start & draw the vertex using the custom drawVertex() method
  }
  endShape(); // finalize the Shape
  popMatrix(); // use push/popMatrix so each Shape's translation does not affect other drawings
}
