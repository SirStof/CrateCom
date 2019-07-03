class SyntaxAnalyser
{
  String regex1, regex2;
  ArrayList<String> text;
  ArrayList<String> variables;
  ArrayList<Pair <String, Integer> > states;
  
  ArrayList< ArrayList<Animation> > animations;
  MemoryBox[] mem;
  int index;
  
  public class Pair<L,R>
  {
    public final L left;
    public final R right;
  
    public Pair(L left, R right)
    {
      this.left = left;
      this.right = right;
    }
  };
  
  public SyntaxAnalyser(MemoryBox[] m)
  {
    //regex = "([+\\-*\\/']+)|([0-9]+)|(=)|(print\\((.*)\\))|([a-zA-Z]+)";
    //regex = "(([A-Za-z]) ?= ?(.*))|(print\\((.*)\\))";
    regex1 = "(^[a-zA-Z][a-zA-Z0-9_]*|) ?= ?(.*)";
    regex2 = "^print\\( ?(.*)\\)";
    states = new ArrayList<Pair<String, Integer > >();
    animations = new ArrayList<ArrayList<Animation> >();
    mem = m;
    index = 0;
  }
  
  public MemoryBox initialized(String s)
  {
    for(int i=0;i<animations.size();i++)
      for(int j=0;j<animations.get(i).size();j++)
        if(!(animations.get(i).get(j).n == null) && animations.get(i).get(j).n.equals(s))
          return animations.get(i).get(j).m;
    return null;
  }
  
  public void analyze(ArrayList<String> t)
  {
    println("analyzing");
    text = t;
    index = 0;
    for(int i=0;i<text.size();i++)
    {
      String line = text.get(i).trim();
      line = line.replaceAll(" +", " ");
      if(line.length() < 1)
        continue;
      String[][] m1 = matchAll(line, regex1);
      String[][] m2 = matchAll(line, regex2);
      
      println();
      
      ArrayList<Animation> animlist = new ArrayList<Animation>();
      
      if(m1 != null) // found assignment
      {
        Value vBox;
        MemoryBox mBox1, mBox2 = null;
        // check if group 1 is a variable
        if(m1[0][1].length() < 1)
        {
          // syntax error, lefthand side is empty
          mBox1 = mem[index];
        }
        else
        {
          // check if it is previously allocated
          // if not, allocate
          mBox1 = initialized(m1[0][1]);
          if(mBox1 == null)
          {
            Animation point = new Animation_Pointer(mem[index], arrow[0]);
            Animation anim = new Animation_Alloc(mem[index], m1[0][1]);
            animlist.add(0, point);
            animlist.add(anim);

            mBox1 = mem[index];
            index++;
          }
          else
          {
            animlist.add(new Animation_Pointer(mBox1, arrow[0]));
            animlist.add(new Animation_Delete(mBox1.value));
          }
        }
        // check if group 2 is a valid variable or value
        if(m1[0][2].length() < 1)
        {
          //syntax error, righthand side is empty
        }
        else
        {
          // if variable, check if it is allocated
          // "^[a-zA-Z][a-zA-Z0-9_]*$|^[0-9]+$"
          // regex /\, left = var, right is integer
          String[][] m3 = matchAll(m1[0][2], "^[a-zA-Z][a-zA-Z0-9_]*$");
          String[][] m4 = matchAll(m1[0][2], "^[0-9]+$");
          if(m3 != null) // other var
          {
            mBox2 = initialized(m3[0][0]);
            if(mBox2 == null)
            {
              // righthandside is a name of an unrecognized variable
            }
            else
            {
              // copy
              // moveX
              // optional delete
              // moveY
              Value v = new Value();
              animlist.add(1, new Animation_Pointer(mBox2, arrow[1]));
              animlist.add(2, new Animation_Copy(mBox2, v));
              animlist.add(3, new Animation_Move(v, mBox1.x,292.5,mBox1.z, 1));
              if(animlist.size() > 4 && animlist.get(4).t == Animation_Type.ALLOC)
                animlist.add(1, animlist.remove(4));
              animlist.add(new Animation_Set(v, mBox1));
              mBox1.value = v;
            }
          }
          else if(m4 != null) // integer value
          {
            Value value = new Value();
            value.setValue(Integer.parseInt(m4[0][0]));
            animlist.add(1, new Animation_Create(value));
            animlist.add(2, new Animation_Move(value, mBox1.x,292.5,mBox1.z, 2));
            if(animlist.get(3).t == Animation_Type.ALLOC)
                animlist.add(1, animlist.remove(3));
            animlist.add(new Animation_Set(value, mBox1));
            mBox1.value = value;
          }
          // anything else is syntax error
        }
        // check if line contains more than just this.
        println(m1[0][1]);
        println(m1[0][2]);
      }
      else if(m2 != null) // found print
      {
        MemoryBox mBox;
        // check if group is valid variable with valid value
        String check = m2[0][1];
        if(check.charAt(check.length()-1) == ' ')
          check = check.substring(0, check.length()-1);
        
        mBox = initialized(check);
        if(mBox == null) 
        {
          // printing a variable that doesn't exist (yet, or isn't even a variable)
        }
        else
        {
          Value v = new Value();
          animlist.add(new Animation_Pointer(mBox, arrow[1]));
          animlist.add(new Animation_Copy(mBox, v));
          animlist.add(new Animation_Print(v));
        }
        // animation
        // check if line contains more than just this.
        println(check);
        
      }
      else // found something else, not parsable
      {
        // error
      }
      animations.add(animlist);
    }
  }
}
