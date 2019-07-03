import java.awt.Robot;
import java.awt.Rectangle;
import java.awt.AWTException;

import processing.pdf.*;

// 
float textangle;

// Text stuff
PGraphics pg;


boolean mouse = true;
boolean editMode = false;
boolean light = false;

int playMode = 0;

int record;

FirstPersonPerspective fpp;
TextEditor editor;
Output output;
SyntaxAnalyser syntaxer;

ArrayList< ArrayList<Animation> > animlist;
ArrayList<Animation> testlist;
int animline, animindex;

MemoryBox mem[];

ArrayList<Value> valList;

Casing casing;

Value val1, val2;

Button playAllButton, playOneButton, resetButton;

Printer printer;

MemoryPointer arrow[];

int z = 500;
//float x = 427.5;

void setup() {
  fullScreen(P3D, 1);

  fpp = new FirstPersonPerspective(this);
  editor = new TextEditor(this);
  editor.enable();
  output = new Output(this);
  mem = new MemoryBox[7];
  for(int i=0;i<7;i++)
  {
    mem[i] = new MemoryBox();
    mem[i].x = -427.5+i*125;
    mem[i].y = 450;
    mem[i].z = 450;
  }
  syntaxer = new SyntaxAnalyser(mem);
  
  valList = new ArrayList<Value>();
  playAllButton = new PlayAllButton(width-80-50, 350, 50, 50);
  playOneButton = new PlayOneButton(width-10-50, 350, 50, 50);
  resetButton =   new ResetButton(width-150-50,350,50,50);
  
  val1 = new Value();
  val1.setValue(2);
  val1.x = -427.5+6*125;
  val1.y = 342.5;
  val1.z = 450;
  
  val2 = new Value();
  val2.setValue(3);
  val2.x = 440;
  val2.y = 342.5;
  val2.z = 450;
  
  arrow = new MemoryPointer[2];
  
  for(int i=0;i<2;i++)
  {
    arrow[i] = new MemoryPointer();
    arrow[i].x = -427.5+i*125;
    arrow[i].y = 477.5+6;
    arrow[i].z = 510;
  }
  
  printer = new Printer();
  
  //valList.add(val1);
  //valList.add(val2);
  
  animlist = null;
  testlist = null;
  animindex = 0;
  animline = 0;
  
  casing = new Casing();
  
  // TEXT STUFF
  textSize(100);
  pg = createGraphics(500, 500, P2D);
  // ---------------
  
  // TEXT MODE
  textMode(MODEL);
  textSize(120);
  textangle = 0;
    frameRate(60);
 
}
void draw() {
  background(0);
  
  hint(ENABLE_DEPTH_TEST);
  
  fill(255);
  for(int i=0;i<2;i++)
  {
    pushMatrix();
    translate(arrow[i].x,arrow[i].y,arrow[i].z);
    shape(arrow[i].get());
    popMatrix();
  }
  
  ambientLight(100,100,100);
  directionalLight(128, 128, 128, -.5, .5, -1);
  
  pushMatrix();
  translate(printer.x,printer.y,printer.z);
  shape(printer.get());
  popMatrix();
  
  if(playMode > 0)
  {
    if(animlist.size() > 0)
    {
      editor.highlightLine(animline+1);
      if(animlist.get(animline).get(animindex).getState() == Thread.State.TERMINATED)
      {
        if(animindex < animlist.get(animline).size()-1)
          animindex++;
        else if(animline < animlist.size()-1)
        {
          animindex = 0;
          animline++;
          
          arrow[0].y = 477.5+6;
          arrow[1].y = 477.5+6;
  
          if(playMode > 1)
            playMode = 0;
        }
        else
        {
          arrow[0].y = 477.5+6;
          arrow[1].y = 477.5+6;
          playMode = 0;
          editor.highlightLine(-1);
        }
      }
      else if(animlist.get(animline).get(animindex).getState() == Thread.State.NEW)
      {
        animlist.get(animline).get(animindex).start();
        if(animlist.get(animline).get(animindex).t == Animation_Type.ALLOC)
          animlist.get(animline).get(animindex).m.setVariable(animlist.get(animline).get(animindex).n);
        else if(animlist.get(animline).get(animindex).t == Animation_Type.COPY)
          animlist.get(animline).get(animindex).v.setValue(animlist.get(animline).get(animindex).m.value.value);
      }
      else if(animlist.get(animline).get(animindex).t == Animation_Type.PRINT)
      {
        if(((Animation_Print)animlist.get(animline).get(animindex)).print)
        {
          ((Animation_Print)animlist.get(animline).get(animindex)).print = false;
          printer.output(""+animlist.get(animline).get(animindex).v.value);
        }
      } 
    }
  }

  fill(255);
  for(int i=0;i<7;i++)
  {
    pushMatrix();
    //translate(427.5-i*125,450,450);
    translate(mem[i].x,mem[i].y,mem[i].z);
    shape(mem[i].get());
    popMatrix();
  }

  for(int i=0;i<valList.size();i++)
  {
    if(valList.get(i).moving)
    {
      valList.get(i).x += valList.get(i).vx;
      valList.get(i).y += valList.get(i).vy;
      valList.get(i).z += valList.get(i).vz;
    }
    pushMatrix();
    translate(valList.get(i).x,valList.get(i).y,valList.get(i).z);
    shape(valList.get(i).get());
    popMatrix();
  }
  
  shape(casing.get());

  hint(DISABLE_DEPTH_TEST);
  camera();
  noLights();
  editor.draw();
  playAllButton.draw(mouseX, mouseY);
  
  playOneButton.draw(mouseX, mouseY);
  
  resetButton.draw(mouseX, mouseY);
  
  // ------------------
  
  fpp.update();
  
}
void addValue(Value val)
{
  valList.add(val);
}

void keyPressed()
{
  fpp.keyPressed();
  editor.keyPressed();
  if(key == '|')
    fpp.toggle();
  
 
}
void resetAll()
{
  valList.clear();
  playMode = 0;
  printer.reset();
  for(int i=0;i<7;i++)
  {
    mem[i].value = null;
    mem[i].copy = null;
    mem[i].setVariable("");
    mem[i].used = false;
  }
  syntaxer.animations.clear();
  animlist = null;
  animindex = 0;
  animline = 0;
  
  arrow[0].y = 477.5+6;
  arrow[1].y = 477.5+6;
  
  editor.highlightLine(-1);
}
void keyReleased()
{
  fpp.keyReleased();
}
void mouseWheel(MouseEvent event) {
  editor.mouseWheel(event);
}
void mousePressed()
{
  if(playAllButton.mousePressed(mouseX, mouseY))
  {
    if(animlist == null)
    {
      syntaxer.analyze(editor.getText());
      animlist = syntaxer.animations;
    }
    playMode = 1;
  }
  else if(playOneButton.mousePressed(mouseX, mouseY))
  {
    if(animlist == null)
    {
      syntaxer.analyze(editor.getText());
      animlist = syntaxer.animations;
    }
    playMode = 2;
  }
  else if(resetButton.mousePressed(mouseX, mouseY))
  {
    resetAll();
  }
  for(int i=0;i<2;i++)
    arrow[i].get().setFill(color(100));
    
  //if(mouseButton == RIGHT)
  //  saveFrame();
}
void mouseReleased()
{
  for(int i=0;i<2;i++)
    arrow[i].get().setFill(color(255));
}
