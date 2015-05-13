

import processing.opengl.*; // import the OpenGL core library

int NUMSEGMENTS = 16; // the number of segments for the shapes
float DIAM_FIXED = 300; // the diameter of the rotating shape with the fixed texture
float DIAM2_FIXED = 150; // the diameter of the rotating shape with the fixed texture
float DIAM_INNER = 125; // the inner diameter of the moving shape with the moving texture
float DIAM_OUTER = 275; // the outer diameter of the moving shape with the moving texture
float DIAM_INNER2 = 125; // 
float DIAM_OUTER2 = 335; // 

// arrays to store the pre-calculated xy directions of all segments
float[] xL = new float[NUMSEGMENTS];
float[] yL = new float[NUMSEGMENTS];

PImage[] images = new PImage[5]; // array to hold 4 input images
int currentImage; // variable to keep track of the current image
int currentImage2; //for the second 
float fc1, fc2; // global variables used by many vertices for their dynamic movement

void setup() {
  size(800, 600, OPENGL); // use the OpenGL renderer
  textureMode(NORMAL); // set texture coordinate mode to NORMALIZED (0 to 1)
  smooth();

  // load the images from the _Images folder (relative path from this sketch's folder)
  images[0] = loadImage("../_Images/cyclone.jpg");
  images[1] = loadImage("../_Images/rardar.jpg");
  images[2] = loadImage("../_Images/happiness_texture.png");
  images[3] = loadImage("../_Images/topo.jpg");
  images[4] = loadImage("../_Images/particles.jpg");
  currentImage = int(random(images.length)); // randomly choose the currentImage
  currentImage2 = int(random(images.length));

  float step = TWO_PI/NUMSEGMENTS; // generate the step size based on the number of segments
  // pre-calculate x and y based on angle and store values in two arrays
  for (int i=0; i<xL.length; i++) {
    float theta = step * i; // angle for this segment
    xL[i] = sin(theta);
    yL[i] = cos(theta);
  }
}

void draw() { //background image
  image(images[currentImage], 0, 0, width, float(width)/height*images[currentImage].height); // resize-display image correctly to cover the whole screen
  fill(255, 125+sin(frameCount*0.01)*5); // white fill with dynamic transparency
  rect(0, 0, width, height); // rect covering the whole canvas
  
  
  /////////
    // second texture
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
////////////
  
  

  // 1. FIXED texture on a MOVING shape
  pushMatrix(); // use push/popMatrix so each Shape's translation does not affect other drawings
  translate(width/2, height/2); // translate to the left-center
  rotate(frameCount*0.01); // rotate around this center
  noStroke(); // turn off stroke
  beginShape(TRIANGLE_FAN); // input the shapeMode in the beginShape() call
  texture(images[4]); // set the texture to use
  vertex(0, 0, 0.5, 0.5); // define a central point for the TRIANGLE_FAN, note the (0.5, 0.5) uv texture coordinates
  for (int i=0; i<NUMSEGMENTS+1; i++) {
    drawVertex(i==NUMSEGMENTS?0:i, DIAM_FIXED); // make sure the end equals the start & draw the vertex using the custom drawVertex() method
  }
  endShape(); // finalize the Shape
  popMatrix(); // use push/popMatrix so each Shape's translation does not affect other drawings

// second MOVING shape
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
//

  // calculate fc1 and fc2 once per draw(), since they are used for the dynamic movement of many vertices
  fc1 = frameCount*0.01;
  fc2 = frameCount*0.02;

  // 2. MOVING texture on a MOVING shape
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












// custom method that draws a vertex with correct position and texture coordinates
// based on index and a diameter input parameters
void drawVertex(int index, float diam) {
  float x = xL[index]*diam; // pre-calculated x direction times diameter
  float y = yL[index]*diam; // pre-calculated y direction times diameter
  // calculate texture coordinates based on the xy position
  float tx = x/images[currentImage].width+0.5;
  float ty = y/images[currentImage].height+0.5;
  // draw vertex with the calculated position and texture coordinates
  vertex(x, y, tx, ty);
}

void keyPressed() {
  currentImage = ++currentImage%images.length; // scroll through images on mouse press
}
void mouseClicked() {
  currentImage2 = ++currentImage2%images.length;
}
