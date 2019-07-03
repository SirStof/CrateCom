class MemoryBox
{
  float x, y, z;

  PImage texture;

  PShape shape;

  String variable;

  float wallWidth;
  float boxHeight;
  float boxWidth;
  float boxDepth;

  PGraphics pg;
  PFont mono;
  
  Value value, copy;
  
  // For syntax analysis
  boolean used;

  public MemoryBox()
  {
    x = 0;
    y = 0;
    z = 0;

    wallWidth = 5;
    boxHeight = 50;
    boxWidth = 120;
    boxDepth = 70;

    variable = "";
    
    used = false;

    texture = loadImage("data/mat_grey.jpg");

    pg = createGraphics((int)boxWidth, (int)boxHeight, P2D);
    mono = createFont("data/font.ttf", 24);

    shape = createShape(GROUP);
    shape.setFill(255);

    textureMode(NORMAL);
    PShape leftWall = createShape(BOX, wallWidth, boxHeight, boxDepth);
    leftWall.translate(boxWidth/2, 0, 0);
    leftWall.setStroke(false);
    leftWall.setTexture(texture);
    shape.addChild(leftWall);

    PShape rightWall = createShape(BOX, wallWidth, boxHeight, boxDepth);
    rightWall.translate(-boxWidth/2, 0, 0);
    rightWall.setStroke(false);
    rightWall.setTexture(texture);
    shape.addChild(rightWall);

    PShape frontWall = createShape(BOX, boxWidth-wallWidth, boxHeight, wallWidth);
    //frontWall.rotateY(PI);
    frontWall.translate(0, 0, boxDepth/2-wallWidth/2);
    frontWall.setStroke(false);
    frontWall.setTexture(texture);
    shape.addChild(frontWall);

    PShape backWall = createShape(BOX, boxWidth-wallWidth, boxHeight, wallWidth);
    backWall.translate(0, 0, -boxDepth/2+wallWidth/2);
    backWall.setStroke(false);
    backWall.setTexture(texture);
    shape.addChild(backWall);

    PShape floor = createShape(BOX, boxWidth+wallWidth, wallWidth, boxDepth);
    floor.translate(0, boxHeight/2.0+wallWidth/2.0, 0);
    floor.setStroke(false);
    floor.setTexture(texture);
    shape.addChild(floor);

    /*PShape lid = createShape(BOX, boxWidth+wallWidth, wallWidth, boxDepth);
     lid.translate(0,-boxHeight/2.0-wallWidth/2.0,0);
     lid.setStroke(false);
     lid.setTexture(texture);
     shape.addChild(lid);*/
  }
  public PShape get() { 
    return shape;
  }

  public boolean setVariable(String var)
  {
    variable = var;
    if (variable.length() > 0)
    {
      //if (variable.length() > 7)
      //  return false;

      pg.beginDraw();
      pg.fill(255);
      pg.background(240);
      pg.textFont(mono);

      pg.image(texture, 0, 0, boxWidth, boxHeight);
      pg.scale(-1, 1);
      pg.textAlign(CENTER);
      pg.text(variable, -60, 35);

      pg.endDraw();
      shape.getChild(2).setTexture(pg);
    }
    else
    {
      variable = "";
      shape.getChild(2).setTexture(texture);
      return false;
    }
    return true;
  }
}

class Casing
{
  int x, y, z;

  PImage texture;

  PShape shape;

  float wallWidth;
  float boxHeight;
  float boxWidth;
  float boxDepth;

  public Casing()
  {
    x = 0;
    y = 0;
    z = 0;

    wallWidth = 20;
    boxHeight = 1200;
    boxWidth = 1000;
    boxDepth = 1000;

    texture = loadImage("data/motherboard.jpg");

    shape = createShape(GROUP);
    shape.setFill(255);

    textureMode(NORMAL);
    PShape leftWall = createShape(BOX, wallWidth, boxHeight, boxDepth);
    leftWall.translate(boxWidth/2, 0, 0);
    leftWall.setStroke(false);
    //leftWall.setTexture(texture);
    leftWall.setFill(color(1, 86, 55));
    shape.addChild(leftWall);

    PShape rightWall = createShape(BOX, wallWidth, boxHeight, boxDepth);
    rightWall.translate(-boxWidth/2, 0, 0);
    rightWall.setStroke(false);
    //rightWall.setTexture(texture);
    //rightWall.setFill(color(206, 181, 115));
    rightWall.setFill(color(1, 76, 50));
    shape.addChild(rightWall);

    PShape frontWall = createShape(BOX, boxWidth-wallWidth, boxHeight, wallWidth);
    frontWall.translate(0, 0, boxDepth/2-wallWidth/2);
    frontWall.setStroke(false);
    frontWall.setFill(color(1, 86, 55));
    shape.addChild(frontWall);

    PShape backWall = createShape(BOX, boxWidth-wallWidth, boxHeight, wallWidth);
    backWall.translate(0, 0, -85+wallWidth/2);
    backWall.setStroke(false);
    //backWall.setTexture(texture);
    backWall.setFill(color(1, 86, 55));
    shape.addChild(backWall);

    PShape floor = createShape(BOX, boxWidth+wallWidth, wallWidth, boxDepth);
    floor.translate(0, boxHeight/2.0+wallWidth/2.0, 0);
    floor.setStroke(false);
    //floor.setTexture(texture);
    floor.setFill(color(1, 86, 55));
    shape.addChild(floor);

    /*PShape lid = createShape(BOX, boxWidth+wallWidth, wallWidth, boxDepth);
     lid.translate(0,-boxHeight/2.0-wallWidth/2.0,0);
     lid.setStroke(false);
     lid.setTexture(texture);
     shape.addChild(lid);*/

    shape.rotateX(-PI/2.0);
  }
  public PShape get() { 
    return shape;
  }
}

class Value
{
  float x, y, z;
  PImage texture;
  PShape shape;
  
  float speed;
  float vx,vy,vz;
  boolean moving;
  int moveTime;

  String variable;
  int value;

  float boxHeight;
  float boxWidth;
  float boxDepth;

  PGraphics pg;
  PFont mono;

  public Value()
  {
    x = 0;
    y = 200;
    z = 1100;
    
    speed = 5;
    vx = 0;
    vy = 0;
    vz = 0;
    moving = false;
    moveTime = 0;
    
    
    texture = loadImage("data/mat_grey.jpg");

    boxHeight = 65;
    boxWidth = 100;
    boxDepth = 60;

    pg = createGraphics((int)boxWidth, (int)boxHeight, P2D);
    mono = createFont("data/font.ttf", 31);
    value = 0;
    variable = "";

    shape = createShape(BOX, boxWidth, boxHeight, boxDepth);
    shape.setStroke(false);
    shape.setFill(color(90, 145, 199));
    shape.rotateY(PI);
  }
  public PShape get() { 
    return shape;
  }

  public void setVariable(String var)
  {
    variable = var;
  }
  public void setValue(int val)
  {
    textureMode(NORMAL);
    value = val;

    pg.beginDraw();
    pg.background(color(255));
    pg.fill(0);
    pg.textFont(mono);
    
    pg.scale(-1, 1);
    pg.textAlign(CENTER, CENTER);
    pg.textLeading(30);
    pg.text(val, -50, 30);
    pg.endDraw();

    shape.setTexture(pg);
  }
  
  public void move(float x, float y, float z, float time, float startup, float slowdown)
  {
  }
  public void move(float x, float y, float z, float time)
  {
    moveTime = (int)(time*1000);
    
    vx = (x - this.x)/(time*60);
    vy = (y - this.y)/(time*60);
    vz = (z - this.z)/(time*60);
    
    thread("timeMove");
  }
  public void moveRel(float x, float y, float z, float time)
  {
    moveTime = (int)(time*1000);
    
    vx = x/(time*60);
    vy = y/(time*60);
    vz = z/(time*60);
    
    thread("timeMove");
  }
}
class Printer
{
  float x,y,z;
  
  PShape shape;
  PGraphics pg[];
  PFont mono;
  
  PShape output[];
  
  ArrayList<String> text;
  
  public Printer()
  {
    x = 0;
    y = 212.5;
    z = 450;
    
    pg = new PGraphics[7];
    for(int i=0;i<7;i++)
      pg[i] = createGraphics(80, 22, P2D);
      
    mono = createFont("data/font.ttf", 28);
    text = new ArrayList<String>();
    
    shape = createShape(GROUP);
    shape.setFill(255);
    shape.setStroke(255);
    
    MemoryBox printerIn = new MemoryBox();
    for(int i=0;i<printerIn.get().getChildCount();i++)
      printerIn.get().getChild(i).setTint(false);
    printerIn.get().rotateX(PI);
    shape.addChild(printerIn.get());
    
    PShape printer = loadShape("data/10107_Computer_Printer_v3_L3.obj");
    printer.scale(3);
    printer.rotateX(PI/2.0);
    printer.rotateY(PI);
    printer.translate(0,-30,0);
    shape.addChild(printer);
    
    output = new PShape[7];
    
    for(int i=0;i<7;i++)
    {
      output[i] = createShape(BOX, 80, 22, 1);
      output[i].setStroke(255);
      output[i].translate(0, -65+(1*22), -25);
      shape.addChild(output[i]);
    }
    output[0].translate(0, -22, 0);
  }
  public PShape get()
  {
    return shape;
  }
  public void reset()
  {
    // todo reset textures, getTextureImage ??
    if(text.size() < 1)
      return;
    for(int i = 0;i < text.size();i++)
    {
      pg[i].beginDraw(); 
      pg[i].clear();
      pg[i].background(255);
      pg[i].endDraw();
      output[i].translate(0, (text.size()-i+1)*22, 0);
    }
    output[0].translate(0, -22, 0);
    output[text.size()].translate(0, 22, 0);

    text.clear();
  }
  public void output(String t)
  {
    text.add(t);
    //shape.removeChild(2);
    pg[text.size()-1].beginDraw();
    pg[text.size()-1].fill(0);
    pg[text.size()-1].background(255);
    pg[text.size()-1].textFont(mono);

    //pg.image(texture, 0, 0, boxWidth, boxHeight);
    pg[text.size()-1].scale(-1, 1);
    pg[text.size()-1].textAlign(LEFT);
    pg[text.size()-1].text(t, -78, 20);
  
    pg[text.size()-1].endDraw();
    output[text.size()-1].setTexture(pg[text.size()-1]);
    Animation_Printer anim = new Animation_Printer(output, text.size()+1);
    anim.start();
    //output[text.size()-1].translate(0,-150,0);
  }
}
class MemoryPointer
{
  float x,y,z;
  PShape shape;
  
  public MemoryPointer()
  {
    x = 0;
    y = 0;
    z = 0;
    
    shape = createShape(GROUP);
    shape.setFill(255);
    
    PShape mid = createShape(BOX, 20, 5, 80);
    mid.setStroke(255);
    mid.translate(0,0,40);
    //mid.setFill(150);
    shape.addChild(mid);
    
    PShape left = createShape(BOX, 20, 5, 50);
    //left.setFill(150);
    left.setStroke(255);
    left.rotateY(-PI/4.0);
    left.translate(-10.5,0,0);
    shape.addChild(left);
    
    PShape right = createShape(BOX, 20, 5, 50);
    //right.setFill(150);
    right.setStroke(255);
    right.rotateY(PI/4.0);
    right.translate(10.5,0,0);
    shape.addChild(right);
    
    shape.scale(0.5);
    
  }
  public PShape get()
  {
    return shape;
  }
}
