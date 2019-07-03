class Button
{
  final float x, y, bWidth, bHeight;
  
  public Button(float x, float y, float w, float h)
  {
    this.x = x;
    this.y = y;
    this.bWidth = w;
    this.bHeight = h;
  }
  public void draw(int mx, int my)
  {
    strokeWeight(1);
    stroke(255);
    if(mx >= x && mx <= x+bWidth && 
        my >= y && my <= y+bHeight)
      fill(255);
    else
      fill(200);
    rect(x, y, bWidth, bHeight);
  }
  public boolean mousePressed(int mx, int my)
  {
    if(mx >= x && mx <= x+bWidth && 
        my >= y && my <= y+bHeight)
      return true;
    return false;
  }
}
class PlayAllButton extends Button
{
  public PlayAllButton(float x, float y, float w, float h)
  {
    super(x,y,w,h);
  }
  public void draw(int mx, int my)
  {
    super.draw(mx, my);
    fill(0);
    stroke(0);
    triangle(x + bWidth/3, y+bHeight/4, x + bWidth/3, y+3*bHeight/4, x + 3*bWidth/4, y+bHeight/2);
  }
}
class PlayOneButton extends Button
{
  public PlayOneButton(float x, float y, float w, float h)
  {
    super(x,y,w,h);
  }
  public void draw(int mx, int my)
  {
    super.draw(mx, my);
    fill(0);
    stroke(0);
    triangle(x + bWidth/3, y+bHeight/4, x + bWidth/3, y+3*bHeight/4, x + 3*bWidth/4, y+bHeight/2);
    strokeWeight(4);
    line(x + 3*bWidth/4, y+bHeight/4, x + 3*bWidth/4, y+3*bHeight/4);
  }
}

class ResetButton extends Button
{
  public ResetButton(float x, float y, float w, float h)
  {
    super(x,y,w,h);
  }
  public void draw(int mx, int my)
  {
    super.draw(mx, my);
    noFill();
    stroke(0);
    strokeWeight(4);
    arc(x+bWidth/2, y+bHeight/2, 25, 25, -PI*3/4.0, PI*3/4.0);
    fill(0);
    strokeWeight(1);
    triangle(x+11, y+11, x+11, y+22, x+22, y+22);
  }
}
