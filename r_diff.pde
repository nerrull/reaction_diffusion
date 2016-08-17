final int BLUR_STATE = 0;
final int SUBTRACT_STATE = 1;
final int WTFSTATE = 2;
final int SECOND_BLUR = 3;
float zero = 0f;
PGraphics layer1;
PGraphics layer2;
PGraphics layer3;

PShader hblur;
PShader vblur;
int dif_size = 500;

int STATE = BLUR_STATE;


int BLUR_SIZE=9;
int NUM_BLURS = 4;

void setup() {
  size(500, 500, P2D);
  background(25);
  //noSmooth();
  layer1 =createGraphics(dif_size,dif_size, P2D);
  layer2 =createGraphics(dif_size,dif_size, P2D);
  layer3 =createGraphics(dif_size,dif_size, P2D);
  

  hblur = loadShader("blur.glsl");
  hblur.set("horizontalPass", 1);
  hblur.set("blurSize", BLUR_SIZE);
  hblur.set("sigma", 5.0f);  
  

  vblur = loadShader("blur.glsl");
  vblur.set("horizontalPass", 0);
  vblur.set("blurSize", BLUR_SIZE);
  vblur.set("sigma", 5.0f);  
  
  blendMode(NORMAL);
  background(255);
  noStroke();
  fill(0);


  layer1.beginDraw();
  layer1.background(255);
  layer1.fill(255);
  layer1.noStroke();
  layer1.ellipse(width/2, height/2, 100, 100); 
  layer1.ellipse(width/3, height/3, 100, 100); 
  layer1.ellipse(2*width/3, 2*height/3, 100, 100); 
  layer1.ellipse(300, 300, 100, 100); 
  layer1.endDraw();


}


void setBlur(int s){
  BLUR_SIZE= s;
  hblur.set("blurSize", BLUR_SIZE);
  vblur.set("blurSize", BLUR_SIZE);
}

void draw() {

 
    frame.setTitle(int(frameRate) + " fps");
 

  switch (STATE) {
    case BLUR_STATE:
      layer1.beginDraw();
      layer1.filter(hblur);
      layer1.filter(vblur);
      layer1.endDraw();  
      //image(layer1, 0,0);
      STATE = SECOND_BLUR;
    break;
    case SECOND_BLUR:

      loadPixels();
      layer2.beginDraw();
      layer2.blendMode(NORMAL);
      layer2.image(layer1.get(0,0,dif_size,dif_size),0,0);
      for (int i = 0; i < NUM_BLURS; ++i) {
        layer2.filter(hblur);
        layer2.filter(vblur);
      }
      layer2.endDraw();
      //image(layer2, 0,0);
      

      STATE = SUBTRACT_STATE;
    break;
    case SUBTRACT_STATE:
    //println("sub: ");

     layer3.beginDraw();
     layer3.blendMode(NORMAL);
     layer3.image(layer1.get(),0,0);
     layer3.blend(layer2.get(), 0,0, dif_size, dif_size, 0,0, dif_size, dif_size, SUBTRACT);
     
     layer3.filter(THRESHOLD,0.1);
     layer3.filter(DILATE);
     layer3.endDraw();
     layer1.beginDraw();
     layer1.image(layer3.get(),0,0);
     layer1.endDraw();
     image(layer1,0,0);
     STATE = BLUR_STATE;
    break;
    case WTFSTATE:
      blendMode(NORMAL);
      loadPixels();
      println("wtf: ");
      fill(255);
      rect(0, 0, 100,100); 

      filter(hblur);
      //filter(vblur);
    break;
    
  }
  


 }


//
void thresh(){
  color white = color (255,255, 255);
  for (int w = 0; w < dif_size; ++w) {
    for (int h = 0; h < dif_size; ++h) {
      int val = ( pixels[h*width +w]  >> 16) & 0xFF;

      if ( val > 50){
        //println(h*dif_size +w);
        pixels[h*width +w]  = white;
      }
    }
  }
}


void mouseDragged(){
  layer1.beginDraw();
  layer1.ellipse(mouseX,mouseY, 50,50);
  layer1.endDraw();
}

void mousePressed(){
  layer1.beginDraw();
  layer1.ellipse(mouseX,mouseY, 50,50);
  layer1.endDraw();
}

void keyPressed(){
  switch (key) {
    case'w':
      setBlur(min(BLUR_SIZE+1,30));
      println("BLUR_SIZE: "+BLUR_SIZE);
    break;
    case 's':
      setBlur(max(2,BLUR_SIZE-1));
      println("BLUR_SIZE: "+BLUR_SIZE);
    break;
    case'd':
      NUM_BLURS= min(NUM_BLURS+1,100);
      println("NUM_BLURS: "+NUM_BLURS);
    break;
    case 'a':
      
      NUM_BLURS= max(NUM_BLURS-1,1);
      println("NUM_BLURS: "+NUM_BLURS);
    break;
    
  }
}

  /*layer1.beginDraw();
  //layer1.filter(blur);
  layer1.endDraw();


  layer1.loadPixels();
  layer2.loadPixels();
  arrayCopy(layer1.pixels, layer2.pixels, layer1.pixels.length);
  layer2.updatePixels();

  //layer2.loadPixels();


  layer2.beginDraw(); 
  //layer2.rect(0,0, 10,10);
  layer2.filter(blur);
  layer2.filter(blur);
  layer2.filter(blur);
  layer2.filter(blur);
  //layer2.blendMode(SUBTRACT);
  //layer2.image(layer1.get(),0,0);  
  //layer2.blendMode(NORMAL);
  layer2.endDraw();

  //arrayCopy(layer2.pixels, layer1.pixels, layer1.pixels.length);*/

  //removeCache(layer2);
  //image(layer2, 0, 0);*/
  //image(layer1,300,300);



  //image(get(0,0,dif_size,dif_size),200,0);