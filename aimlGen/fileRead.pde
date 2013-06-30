boolean fileRead() {
  fbElement = loadStrings("../bots/super/config/predicates.txt");
  if (fbElement != null) {
    for (int i=0; i<fbElement.length; i++) {
      fbElement[i] = fbElement[i].substring(0, fbElement[i].indexOf(':'));
    }
    fbH = fbElement.length*20;
    for (int i=0; i<fbElement.length; i++) {
    }
  }

  String file[];
  try {
    file = loadStrings("save.txt");
    String t = file[0];
  } 
  catch (Exception e) {
    return false;
  }
  topic = file[0];
  int boxAm = int(file[1]);
  bx = new responseBox[boxAm];
  int bID;
  int bX;
  int bY;
  int bW;
  int bH;
  String bTxt;
  int bPrev;
  int bPrevOut;

  String fTxt;
  int fX;
  int fY;
  int fW;
  int fH;

  int start = 2;
  for (int i=0; i<boxAm; i++) {
    bID = int(i);
    bX = int(file[1+start]);
    bY = int(file[2+start]);
    bW = int(file[3+start]);
    bH = int(file[4+start]);
    bTxt = file[5+start];
    bPrev = int(file[6+start]);
    bPrevOut = int(file[7+start]);

    bx[i] = new responseBox(bID, bW, bH, bX, bY);
    bx[i].txt = bTxt;
    bx[i].prevID = bPrev;
    bx[i].prevOutID = bPrevOut;

    int fieldAm = int(file[8+start]);

    bx[i].output = new field[fieldAm];
    start += 9;
    for (int j=0; j<fieldAm; j++) {
      fTxt = file[0+start];
      fX = int(file[1+start]);
      fY = int(file[2+start]);
      fW = int(file[3+start]);
      fH = int(file[4+start]);

      bx[i].output[j] = new field(fTxt, fX, fY, fW, fH);
      start += 5;
    }
  }
  return true;
}

