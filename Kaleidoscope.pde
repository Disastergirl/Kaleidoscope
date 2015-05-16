import processing.opengl.*; // import the OpenGL core library
import ddf.minim.analysis.*;
import ddf.minim.*;


CircularLayer[] layers;
PImage[] images; // array to hold 4 input images
int currentImage; // variable to keep track of the current image
int currentImage2; //for the second

AudioInput audioSource;


void setup()
{
  size(1000, 1000, OPENGL); // use the OpenGL renderer
  textureMode(NORMAL); // set texture coordinate mode to NORMALIZED (0 to 1)
  smooth(4);

  setupImages();

  audioSource = new Minim(this).getLineIn(Minim.MONO, 2048, 22050);

  setupLayers();
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

void setupLayers()
{
  layers = new CircularLayer[]{
    new SpectrogramLayer(images[0], 512, 125, 290, audioSource),
    //new OuterMovingShape(images[4], 16, 300),
    //new FoobarLayer(images[3], 16, 125, 275),
    //new CentreMovingShape(images[currentImage2], 16, 150),
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
