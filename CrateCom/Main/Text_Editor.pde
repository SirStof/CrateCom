class TextEditor
{
  private ArrayList<String> text;
  private int lineno, index;
  private int textsize;
  private int x,y, xl,yl;
  private PFont mono;
  private PGraphics pg;
  private int verticalSpacing;
  private boolean active;
  private PApplet parent;
  private float cursorTime;
  private int textOffset;
  private int highlight;
  
  public TextEditor(PApplet parent)
  {
    this.parent = parent;
    text = new ArrayList<String>();
    lineno = 0;
    index = 0;
    textsize = 40;
    verticalSpacing = 4;
    textOffset = 30;
    mono = createFont("data/font.ttf", textsize);
    xl = 500;
    yl = 7*40+15*4;
    pg = createGraphics(xl, yl, P2D);
    text.add("");
    active = false;
    highlight = -1;
  }
  public void draw()
  {
    if(!active)
      return;
     
    pg.beginDraw();
    pg.background(240);
    /*pg.stroke(255,0,0);
    for(int i=0;i<11;i++){
      pg.line(textOffset+22*i, 0, textOffset+22*i, yl);
      pg.line(0, (i+1)*textsize + verticalSpacing*(2*i), xl, (i+1)*textsize + verticalSpacing*(2*i));
    }*/
    pg.stroke(0);
    
    // cursor
    pg.strokeWeight(1);
    cursorTime += 1.0/parent.frameRate;
    if(cursorTime >= 1.0)
      cursorTime -= 1.0;
    if(cursorTime < 0.5)
      pg.line(22*index+textOffset,(lineno)*textsize+lineno*2*verticalSpacing + verticalSpacing,22*index+textOffset,(lineno)*textsize+lineno*2*verticalSpacing+textsize + 3*verticalSpacing);
    //
    if(highlight > 0)
    {
      pg.stroke(200,255,200);
      pg.fill(150,255,150);
      pg.rect(0, (highlight-1)*textsize+(highlight-1)*2*verticalSpacing + verticalSpacing, xl, 2*verticalSpacing+textsize);
    }
    pg.textFont(mono);

    
    for(int i = 0; i < text.size();i++)
    {
      pg.fill(200);
      pg.text(i+1, 0,(i+1)*textsize + verticalSpacing*(2*i)); // lineno
      pg.fill(20);
      pg.text(text.get(i), textOffset, (i+1)*textsize + verticalSpacing*(2*i));
    }
    pg.stroke(200);
    pg.strokeWeight(2);
    pg.line(25, 0, 25, yl); // kantlijn
    pg.endDraw();
    parent.image(pg, parent.width-xl-5,5);
  }
  public void enable()
  {
    active = true;
    cursorTime = 0;
  }
  public void disable()
  {
    active = false;
  }
  public void toggle()
  {
    active = !active;
  }
  void keyPressed()
  {
    if(!active)
      return;
    cursorTime = 0;
    
    if(parent.key == '\'')
    {
      text.add(lineno, text.get(lineno).substring(0,index) + "\'" + text.get(lineno).substring(index));
      index++;
      text.remove(lineno+1);
    }
    else if(parent.key == '\"')
    {
      text.add(lineno, text.get(lineno).substring(0,index) + "\"" + text.get(lineno).substring(index));
      index++;
      text.remove(lineno+1);
    }
    else if(parent.key == BACKSPACE) // backspace
    {
      if(index > 0)
      {
        index--;
        text.add(lineno, text.get(lineno).substring(0, index) + text.get(lineno).substring(index+1));
        text.remove(lineno+1);

      }
      else if(lineno > 0)
      {
        lineno--;
        index = text.get(lineno).length();
        text.add(lineno, text.get(lineno) + text.get(lineno+1));
        text.remove(lineno+1);
        text.remove(lineno+1);
      }
    }
    else if(parent.key == DELETE) // delete
    {
      if(index < text.get(lineno).length())
      {
        text.add(lineno, text.get(lineno).substring(0, index) + text.get(lineno).substring(index+1));
        text.remove(lineno+1);
      }
      else if(lineno != text.size()-1)
      {
        text.add(lineno, text.get(lineno) + text.get(lineno+1));
        text.remove(lineno+1);
        text.remove(lineno+1);
      }
    }
    else if(parent.key == RETURN || parent.key == ENTER) // newline
    {
       if(text.size()<7)
       {
         text.add(lineno+1, text.get(lineno).substring(index));
         text.add(lineno+1, text.get(lineno).substring(0,index));
         text.remove(lineno);
         lineno++;
         index = 0;
       }
    }
    else if(parent.keyCode == UP) // up
    {
      if(lineno > 0)
        lineno--;
      if(index > text.get(lineno).length())
        index = text.get(lineno).length();
    }
    else if(parent.keyCode == DOWN) // down
    {
      if(lineno < text.size()-1)
        lineno++;
      if(index > text.get(lineno).length())
        index = text.get(lineno).length();
    }
    else if(parent.keyCode == LEFT) // left
    {
      if(index > 0)
        index--;
      else if(lineno > 0)
      {
        lineno--;
        index = text.get(lineno).length();
      }
    }
    else if(parent.keyCode == RIGHT) // right
    {
      if(index < text.get(lineno).length())
        index++;
      else if(lineno < text.size()-1)
      {
        lineno++;
        index = 0;
      }
    }
    // letters/numbers/symbols.
    else if((parent.key != CODED) && parent.keyCode > 31 && parent.key != 0)
    {
      // check for maximum length? 21
      if(text.get(lineno).length() < 21)
      {
        text.add(lineno, text.get(lineno).substring(0,index) + key + text.get(lineno).substring(index));
        index++;
        text.remove(lineno+1);
      }
    }
  }
  void mouseWheel(MouseEvent event)
  {
    println(event.getCount());
  }
  void mouseClicked()
  {
    
  }
  public void highlightLine(int line)
  {
    if(line < 8)
      highlight = line;
  }
  /*private void syntaxHighlight(int lineno)
  {
  }*/
  public ArrayList<String> getText()
  {
    return text;
  }
};

class Output
{
  PApplet parent;
  int x,y, xl, yl;
  ArrayList<String> output;
  PFont mono;
  PGraphics pg;
  int textsize, textOffset, verticalSpacing;
  
  public Output(PApplet p)
  {
    parent = p;
    output = new ArrayList<String>();
    textsize = 40;
    verticalSpacing = 4;
    textOffset = 50;
    mono = createFont("data/font.ttf", textsize);
    xl = 500;
    yl = 7*40+15*4;
    pg = createGraphics(xl, yl, P2D);
  }
  public void draw()
  {
    pg.beginDraw();
    pg.background(0);
    /*pg.stroke(255,0,0);
    for(int i=0;i<11;i++){
      pg.line(textOffset+22*i, 0, textOffset+22*i, yl);
      pg.line(0, (i+1)*textsize + verticalSpacing*(2*i), xl, (i+1)*textsize + verticalSpacing*(2*i));
    }*/
    pg.stroke(240);
    pg.fill(240);
    
    pg.textFont(mono);
    
    for(int i = 0; i < output.size();i++)
    {
      pg.text(">", 0,(i+1)*textsize + verticalSpacing*(2*i));
      pg.text(output.get(i), textOffset, (i+1)*textsize + verticalSpacing*(2*i));
    }

    pg.endDraw();
    parent.image(pg, parent.width-5-xl, 5);
  }
}
