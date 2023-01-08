//score nie dziala reszta jest ok
//sterowanie myszką, start lpm/lmb
//cheat mozna odbijac za pomoca lpm/lmb piłke

Ball ball;
Paddle paddle;
Block[][] block;//1row,2col
int score;

void setup() {
  size(900, 900);
  ball=new Ball();
  paddle=new Paddle();
  block=new Block[8][4];//customable num of blocks
  score=0;

  for (int i=0; i < block.length; i++) {
    for (int m=0; m<block[0].length; m++) {
      block[i][m]=new Block(m, i, block.length);//row,col numbers //!!!!j into m!!!!!
    }
  }
}

void draw() {
  background(0);
  ball.display();
  ball.checkPaddle(paddle);
  paddle.display();
  //block.display();
  //showScore();//nie dziala

  for (int i=0; i < block.length; i++) {
    for (int m=0; m<block[0].length; m++) {
      block[i][m].display();
      block[i][m].checkBall(ball);
    }
  }
}


// klasy piłki
void mousePressed() {
  ball.y-=4;//prevent cheating by glith ball by bottom paddle
  ball.Vy=-5;
  ball.x-=4;//prevent cheating by glith ball by bottom paddle
  ball.canMove=true;
}

class Ball {
  //variables
  private float x, y, Vx, Vy, d;//v-velocity,d-diameter
  private boolean canMove;


  //constructor
  public Ball() {
    x=width/2;
    y=height-70;
    d=20;
    Vx=random(-5, 5);
    Vy=-7;

    canMove=false;//potrzeba klikniecia by pilka wystartowala
  }

//score
void showScore(){
  
  strokeWeight(3);
  fill(230,0,230);
  text("Score: " +score,width -140,height-10);
}

  //method(display)
  public void display() {

    stroke(0, 150, 0);//added stroke to objects
    fill(0, 150, 150);//color of ball/paddle

    ellipse(x, y, d, d);
    if (canMove) {
      x+=Vx;
      y+=Vy;
      //check left top right
      if (x>width -5 || x<5) {
        Vx*=-1;//delete stuck on wall
      }
      if (y<5) {//bottom
        Vy*=-1;
      }
      if (y>height) {
        canMove=false;
        y=height-70;//delete d to -70 to applay reset option and apply ball to top paddle
        Vy=-5;//for apply again right shoot. the number must be a negative to shoot up
      }
    } else {
      x=mouseX;//start following ball to paddle
    }
    fill(100,100,100);
    ellipse(x,y,d,d);
  }
  public void checkPaddle(Paddle pad) {//adding colision and name paddle as pad
    if(x>pad.x && x<pad.x+pad.w && y>pad.y-d/2&&y<pad.y+2){ //upgraded mess code
    /*if (x>pad.x-pad.w/2 && y>pad.y-pad.h/2 && x<pad.x+pad.w/2) {//mess with code.bad pad collision//hitPaddle realise in x cords and next y cords*/
      Vy*=-1;
      Vx+=(x-mouseX)/10;
    } 
    if(Vx>5){//fast reduce
    Vx=5;
    }
    if(Vx<-5){
     Vx=-5; 
    }
  }
}

//paddle apply

public class Paddle {
  //variables(x,y,width,height(rectangle)
  private float x, y, w, h;//width,height shortcut

  public Paddle() {
    x=width/2;
    y=height-60;//dif 10px
    w=100;//size of paddle
    h=20;//size of paddle
  }

  public void display() {
    fill(0, 150, 190);//seperate paddle color
    x=mouseX-w/2;//move by mouse //upgrade
    //rect(x-w/2, y, w, h); //x-w/2 center paddle to ball
    rect(x, y, w, h);//upgrade
  }
}

//block aplly

public class Block {
  private float x, y, w, h, numBlock;
  private boolean status;
  private int r, g, b;

  public Block() {
    x=0;
    numBlock=8;
    y=0;
    w=width/numBlock; //n number of blocks
    h=20;
  }


  public Block(int row, int col, int theNumBlock) {
    numBlock=theNumBlock;
    w=width/numBlock; //n number of blocks
    h=20;
    x=w*col;//multi blocks
    y=h*row;//
    r=232;
    g=125;
    b=49;
    status=true;
  }



  public void display() {
    fill(r, g, b);
    if (status) {
      rect(x, y, w, h);
    }
  }

  public void checkBall(Ball ball) {
    if (status) {
      //bot
      if (ball.x>x && ball.x<x+w && ball.y<(y+h+ball.d/2) && ball.y>y+h) {
        ball.Vy*=-1;
        status=false;
        score++;
      }
      //top
      if (ball.x>x && ball.x<x+w && ball.y>y-ball.d/2 && ball.y<y) {
        ball.Vy*=-1;
        status=false;
        score++;
      }

      //right
      if (ball.x>x+w && ball.x<x+w+ball.d/2 && ball.y>y && ball.y<y+h) {
        ball.Vx*=-1;
        status=false;
        score++;
      }
      //left
      if (ball.x>x-ball.d/2 && ball.x<x && ball.y>y && ball.y<y+h) {
        ball.Vx*=-1;
        status=false;
        score++;
      }
    }
  }
}
