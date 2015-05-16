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
  layers = new CircularLayer[4];

  layers[0] = new SpectrogramLayer(512, 125, 335, audioSource);
  layers[0].currentImage = images[0];

  layers[1] = new OuterMovingShape(16, 300);
  layers[1].currentImage = images[4];

  layers[2] = new FoobarLayer(16, 125, 275);
  layers[2].currentImage = images[3];

  layers[3] = new CentreMovingShape(16, 150);
  layers[3].currentImage = images[currentImage2];
}

void draw()
{
  drawBackgroundTexture();
  for (CircularLayer l: layers)
    l.run();
}

void keyPressed() {
  currentImage = (currentImage + 1) % images.length;
}

void mouseClicked() {
  currentImage2 = (currentImage2 + 1) % images.length;
  layers[3].currentImage = images[currentImage2];
}
