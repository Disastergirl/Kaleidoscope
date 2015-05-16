class SpectrogramLayer extends CircularLayer
{

	private AudioInput audioSource;
	private FFT fftLog;

	public SpectrogramLayer(PImage img, int segmentCount, int innerRadius, int outerRadius, AudioInput audioSource)
	{
		super(img, segmentCount, innerRadius, outerRadius);
		this.audioSource = audioSource;
		initFFT();
	}

	private void initFFT()
	{
	  // Initialise Fast-Fourier-Transformer
	  fftLog = new FFT(audioSource.bufferSize(), audioSource.sampleRate());
	  fftLog.logAverages(100, 80); // adjust numbers to adjust spacing

	  System.out.format("logarithmic FFT averages: %d\n", fftLog.avgSize());
	  assert fftLog.avgSize() >= segmentCount;
	}

	void run()
	{
		// grab new data window from audio source and calculate FFT
  	fftLog.forward(audioSource.mix);

	  pushMatrix(); // use push/popMatrix so each Shape's translation does not affect other drawings
	  translate(width/2, height/2); // translate to the right-center
	  stroke(255);
	  strokeWeight(0.5);
	  noStroke();
	  beginShape(TRIANGLE_STRIP); // input the shapeMode in the beginShape() call
	  texture(images[0]); // set the texture to use

	  final float level = audioSource.mix.level();

	  for (int i = 0; i < segmentCount + 1; i++)
	  {
	    int imi = i % segmentCount; // make sure the end equals the start

	    // each vertex has a noise-based dynamic movement
	    float dynamicOuter = pow(fftLog.getAvg(imi) / level, 0.1) * 0.8;

	    drawCircleVertex(imi, innerRadius); // draw the vertex using the custom drawVertex() method
	    drawCircleVertex(imi, outerRadius * dynamicOuter); // draw the vertex using the custom drawVertex() method
	  }

	  endShape(); // finalize the Shape
	  popMatrix(); // use push/popMatrix so each Shape's translation does not affect other drawings
	}

}
