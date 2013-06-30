int editPointSize = 30;


class field {
  String txt;
  int width, height, xpos, ypos;

  field(String t, int x, int y, int w, int h) {
    txt = t;
    xpos = x;
    ypos = y;
    width = w;
    height = h;
  }

  void draw() {
    fill(0, 0, 70);
    rect(xpos, ypos, width, height);
    fill(0, 0, 0);
    text(txt, xpos, ypos, width, height);
  }
}



class responseBox { 
  int id, width, height, xpos, ypos; 
  String txt;
  int prevID;   // number of box connected to
  int prevOutID; // number of the output of box connected to
  field[] output = new field[2];


  responseBox (int idt, int w, int h, int x, int y) {  
    id = idt;
    width = w; 
    height = h; 
    xpos = x;
    ypos = y;
    txt = "";
    output[0] = new field("input", width/2-editPointSize/2, 0, editPointSize, editPointSize);
    for (int i=1; i<output.length; i++) {
      output[i] = new field("", width/(output.length)*(i)-editPointSize/2, height-editPointSize, editPointSize, editPointSize);
    }
    prevID = -1;
  } 

  void show() { 
    textAlign(CENTER,CENTER);
    pushMatrix();
    translate(xpos, ypos);
    if (txtEdit == id && txtField == -1) fill(0, 50, 90);
    else fill(0, 0, 90);
    rect(0, 0, width, height);
    fill(0, 0, 0);
    text(txt, 0, 0, width, height);

    for (int i=0; i<output.length; i++) {
      if (txtEdit == id && txtField == i) fill(0, 50, 90);
      else if (editMode)fill(0, 100, 90);
      else fill(120, 30, 90);
      rect(output[i].xpos, output[i].ypos, output[i].width, output[i].height);
    }
    fill(0, 0, 0);
    for (int i=0; i<output.length; i++) {
      text(output[i].txt, output[i].xpos, output[i].ypos, output[i].width, output[i].height);
    }
    popMatrix();
  }

  void showLines() {
    if (prevID != -1) {
      int destX, destY;
      destX = bx[prevID].output[prevOutID].xpos + bx[prevID].xpos + bx[prevID].output[prevOutID].width/2;
      destY = bx[prevID].output[prevOutID].ypos + bx[prevID].ypos + bx[prevID].output[prevOutID].height/2;
      stroke(0);
      line(xpos+output[0].xpos+output[0].width/2, ypos+output[0].ypos+output[0].height/2, destX, destY);
      //noStroke();
    }
  }
}

