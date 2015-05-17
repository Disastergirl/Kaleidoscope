class SpectrogramLayer extends CircularLayer implements AudioProcessor
{

	private AudioDispatcher audioDispatcher;
	private final FFT fft;
	private final float[] amplitudes, transformbuffer;
	private final int samplesPerSegment;

	public SpectrogramLayer(PImage img, int segmentCount, int innerRadius, int outerRadius, AudioDispatcher audioDispatcher)
	{
		super(img, segmentCount, innerRadius, outerRadius);

		this.audioDispatcher = audioDispatcher;
		amplitudes = new float[audioBufferSize / 2];
		transformbuffer = new float[audioBufferSize];
		samplesPerSegment = amplitudes.length / segmentCount;
		assert samplesPerSegment > 0;
	  fft = new FFT(audioBufferSize);
	  audioDispatcher.addAudioProcessor(this);
	}

	void run()
	{
	  pushMatrix(); // use push/popMatrix so each Shape's translation does not affect other drawings
	  translate(width/2, height/2); // translate to the right-center
	  stroke(255);
	  strokeWeight(0.5);
	  noStroke();
	  beginShape(TRIANGLE_STRIP); // input the shapeMode in the beginShape() call
	  texture(images[0]); // set the texture to use

	  for (int i = 0; i < segmentCount + 1; i++)
	  {
	    int imi = i % segmentCount; // make sure the end equals the start

	    float dynamicOuter = getAvg(imi);
	    //println(dynamicOuter);

	    drawCircleVertex(imi, innerRadius); // draw the vertex using the custom drawVertex() method
	    drawCircleVertex(imi, outerRadius * (dynamicOuter + 1)); // draw the vertex using the custom drawVertex() method
	  }

	  endShape(); // finalize the Shape
	  popMatrix(); // use push/popMatrix so each Shape's translation does not affect other drawings
	}

	private float getAvg(int i)
	{
		final int offset = i * samplesPerSegment;
		float sum = amplitudes[offset];
    for (int j = 1; j < samplesPerSegment; j++)
    	sum += amplitudes[offset + j];
    return sum / samplesPerSegment;
	}

	boolean process(AudioEvent audioEvent)
	{
		float[] audioFloatBuffer = audioEvent.getFloatBuffer();
		System.arraycopy(audioFloatBuffer, 0, transformbuffer, 0, audioFloatBuffer.length);
		fft.forwardTransform(transformbuffer);
		fft.modulus(transformbuffer, amplitudes);
		return true;
	}

	void processingFinished()
	{
		// Nothing to do here
	}

}
