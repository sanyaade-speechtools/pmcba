responseBox[] bx = new responseBox[0];
int clickX, clickY;
int dragID = -1;
boolean editMode = false;
int dragField = -1; // 0 = input field,  1,2,3... = number of output field
int txtEdit = -1;  // id of box that is currently being edited
int txtField = -1;
int buttonSize = 50;
field[] button = new field[10];
PrintWriter file;
boolean topicEdit = false;
String topic = "topicName";
String[] fbElement;
boolean fbShow = false;
boolean saveAs = false;
String saveAsName = "fileName";



void setup() {
  fileRead();
  size(1280, 720);
  //noStroke();
  textAlign(CENTER, CENTER);
  colorMode(HSB, 360, 100, 100);
  button[0] = new field("add node", width-buttonSize, 0, buttonSize, buttonSize);
  button[1] = new field("Topic", width-buttonSize, 1*(buttonSize+10), buttonSize, buttonSize);
  button[2] = new field("Face\nBook", width-buttonSize, 2*(buttonSize+10), buttonSize, buttonSize);
  button[3] = new field("new\ndoc", width-buttonSize, 4*(buttonSize+10), buttonSize, buttonSize);
  button[4] = new field("save AIML", width-buttonSize, 5*(buttonSize+10), buttonSize, buttonSize);
  button[5] = new field("save file", width-buttonSize, 6*(buttonSize+10), buttonSize, buttonSize);
  button[6] = new field("Save file as", width-buttonSize, 7*(buttonSize+10), buttonSize, buttonSize);
  button[7] = new field("Reductions", width-buttonSize, 9*(buttonSize+10), buttonSize, buttonSize);
  button[8] = new field("Save Reductions", width-buttonSize, 10*(buttonSize+10), buttonSize, buttonSize);
  button[9] = new field("Save AIML Reductions", width-buttonSize, 11*(buttonSize+10), buttonSize, buttonSize);
}

void draw() {
  background(90, 0, 50);
  if (topicEdit) fill(0, 100, 100);
  else fill(0, 0, 0);
  text("Topic:\n" + topic, width-100, 20);

  for (int i=0; i<bx.length; i++) {
    if (bx[i] != null) bx[i].show();
  }
  for (int i=0; i<bx.length; i++) {
    if (bx[i] != null) bx[i].showLines();
  }
  for (int i=0; i<button.length; i++) {
    button[i].draw();
  }
  if (fbShow) showFBlist();
  if (saveAs) showSaveAs();
  if (showReduct) drawReduct();
}

void showSaveAs() {
  fill(0, 0, 80);
  rect(width/2-200, height/2-100, 400, 200);
  fill(0, 0, 0);
  text("type the desired filename and press enter to save", width/2-200, height/2-120, 400, 200);
  text(saveAsName, width/2-200, height/2-80, 400, 200);
}


void keyTyped() {
  if (showReduct) {
    if (key == ENTER) {
      redClickedRow = -1;
      redClickedLine = -1;
    }
    else if (key == BACKSPACE && reduct[redClickedRow][redClickedLine].length() > 0) {
      reduct[redClickedRow][redClickedLine] = reduct[redClickedRow][redClickedLine].substring(0, reduct[redClickedRow][redClickedLine].length()-1);
    }
    else if (key != BACKSPACE) reduct[redClickedRow][redClickedLine] += key;
  }

  if (saveAs) {
    if (key == ENTER) {
      saveAs=false;
      fileSave(saveAsName);
    }
    else if (key == BACKSPACE && saveAsName.length() > 0) {
      saveAsName = saveAsName.substring(0, saveAsName.length()-1);
    }
    else if (key != BACKSPACE) saveAsName += key;
  }

  if (topicEdit) {
    if (key == ENTER) topicEdit=false;
    else if (key == BACKSPACE && topic.length() > 0) {
      topic = topic.substring(0, topic.length()-1);
    }
    else if (key != BACKSPACE) topic += key;
  }


  if (txtEdit != -1) {
    if (key == ENTER) {
      txtEdit = -1;
      txtField = -1;
    }
    else if (key == '+') {
      addField(txtEdit);
    }
    else if (key == '-') {
      deleteField(txtEdit);
    }
    else {
      if (txtField > -1) {
        if (key == BACKSPACE && bx[txtEdit].output[txtField].txt.length() > 0) {
          bx[txtEdit].output[txtField].txt =  bx[txtEdit].output[txtField].txt.substring(0, bx[txtEdit].output[txtField].txt.length()-1);
        }
        else if (key != BACKSPACE) bx[txtEdit].output[txtField].txt += key;
      }
      else {
        if (key == DELETE) {
          deleteBox(txtEdit);
        }
        else if (key == BACKSPACE && bx[txtEdit].txt.length() > 0) {
          bx[txtEdit].txt =  bx[txtEdit].txt.substring(0, bx[txtEdit].txt.length()-1);
        }
        else if (key != BACKSPACE && key != ENTER) bx[txtEdit].txt += key;
      }
    }
  }
}

void deleteBox(int id) {
  for (int i=0; i<bx.length; i++) {
    if (bx[i] != null) {
      if (bx[i].prevID == id) bx[i].prevID = -1;
    }
  }
  bx[id] = null;
}

void addField(int i) {
  bx[i].output = (field[])expand(bx[i].output, bx[i].output.length+1);
  bx[i].output[bx[i].output.length-1] = new field("", bx[i].width/(bx[i].output.length)*(bx[i].output.length-1)-editPointSize/2, bx[i].height-editPointSize, editPointSize, editPointSize);
  for (int j=1; j < bx[i].output.length-1; j++) {
    bx[i].output[j].xpos = bx[i].width/(bx[i].output.length)*(j)-editPointSize/2;
  }
}

void deleteField(int i) {
  if (bx[i].output.length > 1) {
    bx[i].output = (field[])shorten(bx[i].output);
    for (int j=1; j < bx[i].output.length; j++) {
      bx[i].output[j].xpos = bx[i].width/(bx[i].output.length)*(j)-editPointSize/2;
    }
    for (int j=0; j < bx.length; j++) {
      if (bx[j] != null) {
        if (bx[j].prevOutID == bx[i].output.length  &&  bx[j].prevID == i) bx[j].prevID = -1;
      }
    }
  }
}

void mouseDragged() {
  if (editMode) {
    if (dragField != -1) {
      line(bx[dragID].output[dragField].xpos+bx[dragID].xpos + bx[dragID].output[dragField].width/2, bx[dragID].output[dragField].ypos+bx[dragID].ypos + bx[dragID].output[dragField].height/2, mouseX, mouseY);
    }
  }
  else if (dragID > -1) {
    bx[dragID].xpos = mouseX-clickX;
    bx[dragID].ypos = mouseY-clickY;
  }
  else if (dragID == -2) {
    fbXpos = mouseX-clickX;
    fbYpos = mouseY-clickY;
  }
}

void mousePressed() {
  if (mouseButton == RIGHT) {
    editMode = !editMode;
  }
  else {
    if (fbShow && mouseX > fbXpos && mouseX < fbXpos+fbW && mouseY > fbYpos && mouseY < fbYpos+fbH) {
      dragID = -2;
      clickX = mouseX-fbXpos;
      clickY = mouseY-fbYpos;
    }
    else if (editMode) {
      for (int i=0; i<bx.length; i++) {
        if (bx[i] != null) {
          int posX = mouseX - bx[i].xpos;
          int posY = mouseY - bx[i].ypos;

          for (int j=0; j<bx[i].output.length; j++) {
            if (posX > bx[i].output[j].xpos && posX < bx[i].output[j].xpos+bx[i].output[j].width && posY >bx[i].output[j].ypos && posY < bx[i].output[j].ypos+bx[i].output[j].height) {
              dragID = i;
              dragField = j;
            }
          }
        }
      }
    }
    else {
      for (int i=0; i<bx.length; i++) {
        if (bx[i] != null) {
          if (mouseX > bx[i].xpos && mouseX < bx[i].xpos+bx[i].width && mouseY > bx[i].ypos && mouseY < bx[i].ypos+bx[i].height) {
            dragID = i;
            clickX = mouseX-bx[i].xpos;
            clickY = mouseY-bx[i].ypos;
          }
        }
      }
    }
  }
}

boolean checkButtonClick(int i) {
  if (mouseX > button[i].xpos && mouseX < button[i].xpos+button[i].width && mouseY > button[i].ypos && mouseY < button[i].ypos+button[i].height ) return true;
  else return false;
}

void addBox() {
  int x = 20;
  int y = 20;
  boolean originalPos = false;
  while (!originalPos) {
    originalPos = true;
    for (int i=0; i<bx.length; i++) {
      if (bx[i] != null) {
        if (x==bx[i].xpos && y==bx[i].ypos) {
          x += 20;
          y += 20;
          originalPos = false;
          break;
        }
      }
    }
  }
  bx = (responseBox[])expand(bx, bx.length+1);
  bx[bx.length-1] = new responseBox(bx.length-1, 200, 120, x, y);
}

void fileSave(String fileName) {
  file = createWriter("data/" + fileName + ".txt");
  file.println(topic);  // first thing in the file is the topic name
  int BXlength = 0;   // store amount of textboxes
  int[] nulls = new int[0];  // store the positions of the deleted boxes
  for (int i=0; i<bx.length; i++) {
    if (bx[i] != null) BXlength++;  // if the box was not deleted, increase the textbox amount
    else {
      nulls = expand(nulls, nulls.length+1);   /// if there was a deleted box, store the position of he empty place in the array
      nulls[nulls.length-1] = i;
    }
  }
  file.println(BXlength);
  for (int i=0; i<bx.length; i++) {
    if (bx[i] != null) {
      file.println(i);
      file.println(bx[i].xpos);
      file.println(bx[i].ypos);
      file.println(bx[i].width);
      file.println(bx[i].height);
      file.println(bx[i].txt);

      int prevIDshift = bx[i].prevID;
      for (int j=0; j<nulls.length; j++) {
        if (nulls[j] < bx[i].prevID) {
          println(bx[i].prevID +" " + nulls[j]);
          prevIDshift = bx[i].prevID-(j+1);
        }
      }
      file.println(prevIDshift);

      file.println(bx[i].prevOutID);
      file.println(bx[i].output.length);
      for (int j=0; j<bx[i].output.length; j++) {

        file.println(bx[i].output[j].txt);
        file.println(bx[i].output[j].xpos);
        file.println(bx[i].output[j].ypos);
        file.println(bx[i].output[j].width);
        file.println(bx[i].output[j].height);
      }
    }
  }
  file.flush(); // Writes the remaining data to the file
  file.close(); // Finishes the file
}

void newDoc() {
  bx = new responseBox[0];
  topic = "topicName";
}

void mouseClicked() {
  if (checkButtonClick(0)) addBox();
  else if (checkButtonClick(1))topicEdit = !topicEdit;
  else if (checkButtonClick(2))fbShow = !fbShow;

  else if (checkButtonClick(3)) newDoc();
  else if (checkButtonClick(4)) saveAiml();
  else if (checkButtonClick(5)) fileSave("save");
  else if (checkButtonClick(6)) saveAs = !saveAs;
  else if (checkButtonClick(7)){
    if(!showReduct){
      loadReduct();
    }
    showReduct = !showReduct;
  }
  else if (checkButtonClick(8)) saveReduct();
  else if (checkButtonClick(9)) saveReductAiml();

  if (showReduct)checkRedClicked();
  else {
    if (fbShow && mouseX > fbXpos && mouseX < fbXpos+fbW && mouseY > fbYpos && mouseY < fbYpos+fbH) {
      clickX = mouseX-fbXpos;
      clickY = mouseY-fbYpos;
      for (int i=0; i<fbElement.length; i++) {
        if (clickY >5+i*20 && clickY < 5+i*20+20) {
          if (txtEdit != -1) {
            bx[txtEdit].txt += "<" + fbElement[i] + ">";
          }
        }
      }
    }


    else {
      txtEdit = -1;
      txtField = -1;
      for (int i=0; i<bx.length; i++) {
        if (bx[i] != null) {
          if (mouseX > bx[i].xpos && mouseX < bx[i].xpos+bx[i].width && mouseY > bx[i].ypos && mouseY < bx[i].ypos+bx[i].height) {
            txtEdit = i;
            clickX = mouseX-bx[i].xpos;
            clickY = mouseY-bx[i].ypos;
            for (int j=0; j<bx[i].output.length; j++) {
              if (clickX > bx[i].output[j].xpos && clickX < bx[i].output[j].xpos+bx[i].output[j].width && clickY >bx[i].output[j].ypos && clickY < bx[i].output[j].ypos+bx[i].output[j].height) {
                txtField = j;
              }
            }
          }
        }
      }
    }
  }
}

void mouseReleased() {
  if (dragField != -1) {
    int releaseID = -1;
    int releaseField = -1;
    for (int i=0; i<bx.length; i++) {
      if (bx[i] != null) {
        int posX = mouseX - bx[i].xpos;
        int posY = mouseY - bx[i].ypos;

        for (int j=0; j<bx[i].output.length; j++) {
          if (posX > bx[i].output[j].xpos && posX < bx[i].output[j].xpos+bx[i].output[j].width && posY >bx[i].output[j].ypos && posY < bx[i].output[j].ypos+bx[i].output[j].height) {
            releaseID = i;
            releaseField = j;
          }
        }
      }
    }

    if (releaseField == 0 && dragField > 0) {
      bx[releaseID].prevID = dragID;
      bx[releaseID].prevOutID = dragField;
      bx[releaseID].output[0].txt = bx[dragID].output[dragField].txt;
    }
    else if (releaseField > 0 && dragField == 0) {
      bx[dragID].prevID = releaseID;
      bx[dragID].prevOutID = releaseField;
      bx[dragID].output[0].txt = bx[releaseID].output[releaseField].txt;
    }
    else if (releaseField == -1 && dragField == 0) {
      bx[dragID].prevID = -1;
      bx[dragID].prevOutID = -1;
      bx[dragID].output[0].txt = "";
    }
  }
  dragID = -1;
  dragField = -1;
}

