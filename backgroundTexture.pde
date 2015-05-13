void drawBackgroundTexture()
{
  // background image
  image(images[currentImage], 0, 0, width, float(width)/height*images[currentImage].height); // resize-display image correctly to cover the whole screen
  fill(255, 125+sin(frameCount*0.01)*5); // white fill with dynamic transparency
  rect(0, 0, width, height); // rect covering the whole canvas
}
