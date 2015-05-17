import processing.opengl.*; // import the OpenGL core library

import javax.sound.sampled.AudioSystem;
import javax.sound.sampled.AudioFormat;
import javax.sound.sampled.AudioInputStream;
import javax.sound.sampled.DataLine;
import javax.sound.sampled.LineUnavailableException;
import javax.sound.sampled.TargetDataLine;

import be.tarsos.dsp.AudioDispatcher;
import be.tarsos.dsp.AudioEvent;
import be.tarsos.dsp.AudioProcessor;
import be.tarsos.dsp.io.TarsosDSPAudioInputStream;
import be.tarsos.dsp.io.jvm.JVMAudioInputStream;
/*
import be.tarsos.dsp.pitch.PitchDetectionHandler;
import be.tarsos.dsp.pitch.PitchDetectionResult;
import be.tarsos.dsp.pitch.PitchProcessor;
import be.tarsos.dsp.pitch.PitchProcessor.PitchEstimationAlgorithm;
*/
import be.tarsos.dsp.util.fft.FFT;


CircularLayer[] layers;
PImage[] images; // array to hold 4 input images
int currentImage; // variable to keep track of the current image
int currentImage2; //for the second

static final int audioBufferSize = 1 << 11;
//AudioInput audioSource;
AudioDispatcher audioDispatcher;
private Thread audioDispatcherThread;


void setup()
{
  size(1000, 1000, OPENGL); // use the OpenGL renderer
  textureMode(NORMAL); // set texture coordinate mode to NORMALIZED (0 to 1)
  smooth(4);

  try {
    setupImages();
    setupAudioDispatcher();
    setupLayers();
    audioDispatcherThread.start();
  } catch (LineUnavailableException ex) {
    exit();
  }
}

void setupImages()
{
  // load the images from the _Images folder (relative path from this sketch's folder)
  images = new PImage[]{
    loadImage("../_Images/cyclone.jpg"),
    loadImage("../_Images/radar.jpg"),
    loadImage("../_Images/happiness_texture.png"),
    loadImage("../_Images/topo.jpg"),
    loadImage("../_Images/particles.jpg")
  };
  currentImage = int(random(images.length)); // randomly choose the currentImage
  currentImage2 = int(random(images.length));
}

void setupAudioDispatcher() throws LineUnavailableException
{
  audioDispatcher = new AudioDispatcher(getLine(1, 22050, 16, audioBufferSize), audioBufferSize, 0);
  audioDispatcherThread = new Thread(audioDispatcher, "Audio dispatching");
}

void setupLayers()
{
  layers = new CircularLayer[]{
    new SpectrogramLayer(images[0], 512, 125, 290, audioDispatcher),
    new OuterMovingShape(images[4], 16, 300),
    new FoobarLayer(images[3], 16, 125, 275),
    new CentreMovingShape(images[currentImage2], 16, 150),
    null
  };
}


void draw()
{
  drawBackgroundTexture();
  for (CircularLayer l: layers) {
    if (l != null)
      l.run();
  }
}


void keyPressed() {
  currentImage = (currentImage + 1) % images.length;
}

void mouseClicked() {
  currentImage2 = (currentImage2 + 1) % images.length;
  layers[3].currentImage = images[currentImage2];
}


static TarsosDSPAudioInputStream getLine(int channels, int sampleRate, int sampleSize, int bufferSize)
  throws LineUnavailableException
{
  return getLine(new AudioFormat(sampleRate, sampleSize, channels, true, true), bufferSize);
}

static TarsosDSPAudioInputStream getLine(AudioFormat format, int bufferSize)
  throws LineUnavailableException
{
  TargetDataLine line = (TargetDataLine) AudioSystem.getLine(
    new DataLine.Info(TargetDataLine.class, format, bufferSize));
  line.open(format, bufferSize);
  line.start();
  return new JVMAudioInputStream(new AudioInputStream(line));
}
