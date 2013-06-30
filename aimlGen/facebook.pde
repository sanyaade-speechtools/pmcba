int fbXpos = 0;
int fbYpos = 0;
int fbW = 100;
int fbH = 500;

void showFBlist() {
  pushMatrix();
  translate(fbXpos, fbYpos);
  fill(0, 0, 90);
  rect(0, 0, fbW, fbH);
  textAlign(LEFT, TOP);
  if (fbElement != null) {
    for (int i=0; i<fbElement.length; i++) {
      fill(0, 0, 70+(i%2)*20);
      rect(0, 5+i*20, fbW, 20);
      fill(0, 0, 0);
      text(fbElement[i], 5, 5+i*20);
    }
  }
  popMatrix();
  textAlign(CENTER, CENTER);
}

