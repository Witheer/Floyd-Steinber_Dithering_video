import processing.video.*;

PImage img;
Capture cam;

void setup(){
  size (1000,500);
  
  cam = new Capture(this, 500, 500);
  cam.start();
  
  img = loadImage("ZombieTest.png");  
  //image(img, 0, 0);
  img.filter(GRAY);
  frameRate(20);
}

void draw(){
  
  if(cam.available()){
    cam.read();
    image(cam, 0, 0);
  }
  
  //cam.filter(GRAY);


  cam.loadPixels();
  for(int y = 0; y < cam.height - 1; y++){
    for(int x = 1; x < cam.width - 1; x++){
        
      color oldPixel = cam.pixels[index(x,y)];

      float oldR = red(oldPixel);
      float oldG = green(oldPixel);
      float oldB = blue(oldPixel);
   
      int colorFactor = 1;
    
      float newR = closestColor(oldR, colorFactor);
      float newG = closestColor(oldG, colorFactor);
      float newB = closestColor(oldB, colorFactor);
    
      cam.pixels[index(x,y)] = color(newR, newG, newB);
      
      float errorR = oldR - newR;
      float errorG = oldG - newG;
      float errorB = oldB - newB;  
      
    
      updatePixel(x + 1, y    , 7/16.0, errorR, errorG, errorB);
      updatePixel(x - 1, y + 1, 3/16.0, errorR, errorG, errorB);
      updatePixel(x    , y + 1, 5/16.0, errorR, errorG, errorB);
      updatePixel(x + 1, y + 1, 1/16.0, errorR, errorG, errorB);

    }
  }
  cam.updatePixels();
  image(cam, 500, 0);





}

int index(int x, int y){
return x + y * cam.width;
}

int closestColor(float currentColor, int numOfColors){
return round(numOfColors * currentColor/ 255) * (255/numOfColors);
}

void updatePixel(int x, int y, float factor, float errorR, float errorG, float errorB){
  
  color oldPixel = cam.pixels[index(x,y)];

  float oldR = red(oldPixel);
  float oldG = green(oldPixel);
  float oldB = blue(oldPixel);
    
  float R = oldR + errorR * factor;
  float G = oldG + errorG * factor;
  float B = oldB + errorB * factor;  
    
  cam.pixels[index(x, y)] = color (R, G, B);
  
}
