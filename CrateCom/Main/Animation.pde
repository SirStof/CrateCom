

class Animation extends Thread {
  public  Animation_Type t;
  public  Value v;
  public  MemoryBox m;
  public  String n;
  public  float x;
  public  float y;
  public  float z;
  public  float time;
  public boolean done;
  Animation next;
  
  public Animation(Animation_Type t) {
    done = false;
    next = null;
    this.t = t;
  }
  public void run()
  {

  }
};
class Animation_Alloc extends Animation
{
  public Animation_Alloc(MemoryBox m, String n)
  {
    super(Animation_Type.ALLOC);
    this.m = m;
    this.n = n;
  }
  public void run()
  {
    delay(1000);
  }
};

class Animation_Create extends Animation
{
  public Animation_Create(Value v)
  {
    super(Animation_Type.CREATE);
    this.v = v;
  }
  public void run()
  {
    addValue(v);
    v.get().scale(0.05);
    v.x = 440;
    v.y = 292.5;
    v.z = 450;
    for(int i=1;i<20;i++)
    {
      float s = 1+ 1.0 / (float)i;
      v.get().scale(s);
      delay(50);
    }
    delay(250);
  }
};

class Animation_Delete extends Animation
{
  public Animation_Delete(Value v)
  {
    super(Animation_Type.DELETE);
    this.v = v;
  }
  public void run()
  {
    Animation move = new Animation_Move(v, v.x,v.y-75,v.z, 1);
    move.start();
    delay(1250);
    for(int i=0;i<19;i++)
    {
      float s = 1- 1.0 / (20-(float)i);
      v.get().scale(s);
      delay(50);
    }
    v.x = 0;
    v.y = 200;
    v.z = 1100;
    delay(250);
  }
};

class Animation_Copy extends Animation
{
  public Animation_Copy(MemoryBox m, Value v)
  {
    super(Animation_Type.COPY);
    this.m = m;
    this.v = v;
  }
  public void run()
  {
    m.copy = v;
    addValue(m.copy);
    m.copy.get().scale(0.05);
    //m.copy.setValue(m.value.value);
    m.copy.x = m.value.x;
    m.copy.y = m.value.y - 32.5;
    m.copy.z = m.value.z;
    
    Animation moveCopy = new Animation_Move(m.copy, m.copy.x,m.copy.y-117.5,m.copy.z, 1);
    moveCopy.start();

    for(int i=1;i<20;i++)
    {
      float s = 1+ 1.0 / (float)i;
      m.copy.get().scale(s);
      delay(50);
    }
    delay(250);
  }
}
class Animation_Move extends Animation
{
  public Animation_Move(Value v, float x, float y, float z, float time)
  {
    super(Animation_Type.MOVE);
    this.v = v;
    this.x = x;
    this.y = y;
    this.z = z;
    this.time = time;
  }
  public void run()
  {
    v.moveTime = (int)(time*1000);
      
    v.vx = (x-v.x)/(time*60);
    v.vy = (y-v.y)/(time*60);
    v.vz = (z-v.z)/(time*60);
    
    v.moving = true;
    delay(v.moveTime);
    v.moving = false;
    v.moveTime = 0;
    v.x = x;
    v.y = y;
    v.z = z;
    v.vx = v.vy = v.vz = 0;
    delay(250);
  }
};

class Animation_Set extends Animation
{
  public Animation_Set(Value v, MemoryBox m)
  {
    super(Animation_Type.SET);
    this.v = v;
    this.m = m;
  }
  public void run()
  {
    Animation move = new Animation_Move(v, v.x,v.y+150,v.z, 1);
    move.start();
    m.value = v;
    delay(1000);
    delay(250);
  }
};
class Animation_Print extends Animation
{
  boolean print;
  public Animation_Print(Value v)
  {
    super(Animation_Type.PRINT);
    this.v = v;
    print = false;
  }
  public void run()
  {
    Animation move1 = new Animation_Move(v, 0, 292.5, 450, 2);
    move1.start();
    delay(2050);
    /*Animation move2 = new Animation_Move(v, v.x,v.y-100,v.z, 1);
    move2.start();
    delay(1050);*/
    Animation delete = new Animation_Delete(v);
    delete.start();
    delay(1250);
    print = true;
    //printer.output(""+v.value);
    delay(1250);
  }
}
class Animation_Printer extends Thread
{
  PShape paper[];
  int index;
  
  public Animation_Printer(PShape[] p, int i)
  {
    paper = p;
    index = i;
  }
  public void run()
  {
    if(index <= paper.length)
    {
      for(int i=0;i<22;i++)
      {
        for(int j=0;j<index;j++)
          paper[j].translate(0,-1,0);
        delay(40);
      }
    }
  }
}
class Animation_Pointer extends Animation
{
  MemoryPointer p;
  public Animation_Pointer(MemoryBox m, MemoryPointer p)
  {
    super(Animation_Type.POINT);
    this.m = m;
    this.p = p;
  }
  public void run()
  {
    p.x = m.x;
    p.y-=2;
    delay(200);
    for(int i=0;i<4;i++)
    {
      p.y--;
      delay(100);
    }
    delay(1000);
  }
}
