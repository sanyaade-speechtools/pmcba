String[][] reduct;
boolean showReduct = false;
int reductBorder = 100;
int txtWidth = 150;
int redClickedRow = -1;
int redClickedLine = -1;


void drawReduct() {

  textAlign(LEFT, TOP);
  fill(0, 0, 80);
  pushMatrix();
  translate(reductBorder, reductBorder);
  rect(0, 0, width-reductBorder*2, height-reductBorder*2);
  if (reduct != null) {
    for (int i=0; i<reduct.length; i++) {
      for (int j=0; j<reduct[i].length; j++) {
        if (redClickedRow == i && redClickedLine == j) {
          fill(0, 70, 80);
        }
        else {
          if (j==0) fill(0, 0, 95);
          else fill(0, 0, 70+((j+i)%2)*15);
        }
        rect(10+i*txtWidth +i*10, 5+j*20, txtWidth, 20);
        fill(0, 0, 0);
        if (reduct[i][j] != null) {
          text(reduct[i][j], 15+i*txtWidth +i*10, 7+j*20);
        }
      }
    }
  }
  popMatrix();
  textAlign(CENTER, CENTER);
}

void loadReduct() {
  String file[] = loadStrings("reductions.csv");
  if (file != null) {
    int xLength, yLength;
    xLength = 1;
    for (int i=0; i<file[0].length(); i++) {
      if (file[0].charAt(i) == ';') xLength++;
    }
    yLength = file.length;

    String fileArray[][] = new String[yLength][xLength];
    for (int i=0; i<fileArray.length; i++) {
      fileArray[i] = split(file[i], ';' );
    }

    reduct = new String[xLength][yLength];

    for (int i=0; i<reduct.length; i++) {
      for (int j=0; j<reduct[0].length; j++) {
        reduct[i][j] = fileArray[j][i];
      }
    }
  }
}

void saveReduct() {
  if (reduct != null) {
    file = createWriter("data/reductions.csv");

    for (int j=0; j<reduct[0].length; j++) {
      if (j!=0) file.println();
      for (int i=0; i<reduct.length; i++) {
        if (i!=0) file.print(";");
        file.print(reduct[i][j]);
      }
    }

    file.flush(); // Writes the remaining data to the file
    file.close(); // Finishes the file
  }
}


void saveReductAiml() {
  if (!showReduct) {
    loadReduct();
  }
  String aiml = "";
  aiml += "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<aiml>";
  for (int i=0; i<reduct.length; i++) {
    aiml += "\n";
    for (int j=1; j<reduct[i].length; j++) {  // start at 1 as 0 is the template
      if (reduct[i][j] != null) {
        // if (reduct[i][j] != null) {
        String category = "";
        category += "\n<category><pattern>";
        category += reduct[i][j].toUpperCase();
        category += "</pattern>\n<template><srai>";
        category += reduct[i][0].toUpperCase();
        category += "</srai></template>\n</category>";
        aiml += category;
      }
    }
    // }
  }
  aiml += "\n\n</aiml>";

  String[] list = split(aiml, '\n' );
  saveStrings("../bots/super/aiml/reductions.aiml", list);
}

void checkRedClicked() {
  if (reduct != null) {
    int clickX = mouseX-reductBorder;
    int clickY = mouseY-reductBorder;

    boolean found = false;
    for (int i=0; i<reduct.length; i++) {
      if (found)break;
      for (int j=0; j<reduct[i].length; j++) {
        if (clickX > (10+i*txtWidth+i*10) &&  clickX < (10+i*txtWidth+i*10)+txtWidth && clickY > (5+j*20) && clickY < (5+j*20)+20) {
          redClickedRow = i;
          redClickedLine = j;
          found = true;
        }
      }
    }
    if (!found) {
      redClickedRow = -1;
      redClickedLine = -1;
    }
  }
}

