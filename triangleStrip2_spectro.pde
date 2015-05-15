class FoobarLayer extends CircularLayer
{

	FoobarLayer(int segmentCount, int innerRadius, int outerRadius)
	{
		super(segmentCount, innerRadius, outerRadius);
	}

	void run()
	{
		// calculate fc1 and fc2 once per draw(), since they are used for the dynamic movement of many vertices
	  float fc1 = frameCount * 0.01;
	  float fc2 = frameCount * 0.02;

	  pushMatrix(); // use push/popMatrix so each Shape's translation does not affect other drawings
	  translate(width/2, height/2); // translate to the right-center
	  noStroke();
	  stroke(255); // set stroke to white
	  beginShape(TRIANGLE_STRIP); // input the shapeMode in the beginShape() call
	  texture(images[3]); // set the texture to use
	  for (int i=0; i<segmentCount+1; i++) {
	    int im = i % segmentCount; // make sure the end equals the start

	    // each vertex has a noise-based dynamic movement
	    float dynamicInner = 0.5 + noise(fc1+im); //replace with audio analysis
	    float dynamicOuter = 0.5 + noise(fc2+im);

	    drawCircleVertex(im, innerRadius * dynamicInner); // draw the vertex using the custom drawVertex() method
	    drawCircleVertex(im, outerRadius * dynamicOuter); // draw the vertex using the custom drawVertex() method
	  }
	  endShape(); // finalize the Shape
	  popMatrix(); // use push/popMatrix so each Shape's translation does not affect other drawings
	}

}
