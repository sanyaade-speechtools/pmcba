void saveAiml() {
  String aiml = "";
  aiml += "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n\n<aiml>\n";
  for (int i=0; i<bx.length; i++) {   /// go through all text boxes
    if (bx[i] != null) {   /// only if it's not deleted
      boolean convStart = false;   
      if (bx[i].prevID == -1) convStart = true;   // the dirst box in the conversation is not linked to another box

      String category = "";  // string for saving the category

      if (!convStart) {   /// if it's linked to another box, make it only respnd if the topic also corresponds
        category += "\n<topic name=\"";
        category += topic.toUpperCase();
        category += "\">";
      }

      ///---PATTERN---///
      category += "\n<category>\n<pattern>";
      category += bx[i].output[0].txt.toUpperCase().replaceAll("[^*A-Z0-9]", "");    /// the pattern it should respond to
      category += "</pattern><that>";


      ///---THAT---///
      if (!convStart) {  // if it has a previous box linked

        String that = fbTagReplace(bx[bx[i].prevID].txt, false);

        int skip = -1;  // position of last character of to be skipped part (only last sentence in THAT)
        int nextSkip;
        skip = that.indexOf("!");
        /*nextSkip = bx[bx[i].prevID].txt.indexOf("?");
         if (nextSkip > skip) skip = nextSkip;
         nextSkip = bx[bx[i].prevID].txt.indexOf(".");
         if (nextSkip > skip) skip = nextSkip;*/
        if (skip != -1) skip++;
        category += that.substring(skip+1).toUpperCase().replaceAll("[^*A-Z ]", "");
      }
      else category += '*';  // if it has no previous box THAT = *
      category += "</that>\n<template>";

      ///---TEMPLATE---///
      String[] tempText = new String[0];
      for (int j=0; j<bx.length; j++) {   /// go through all text boxes to search for boxes connected to the same output field
        if (bx[j] != null) {   /// only if it's not deleted (and it's not already processed before) -> todo
          if (bx[j].prevID == bx[i].prevID  &&  bx[j].prevOutID == bx[i].prevOutID) {  // if it's linked to the same output field
            tempText = expand(tempText, tempText.length+1);
            tempText[tempText.length-1] = bx[j].txt;
          }
        }
      }
      for (int j=0; j<tempText.length; j++) {
        println(tempText[j]);
      }
      println();

      if (tempText.length > 1) category += "<random>";

      for (int j=0; j<tempText.length; j++) {  /// go through all possible answers
        if (tempText.length > 1) category += "\n<li>";
        category += fbTagReplace(tempText[j], true);
        if (tempText.length > 1) category += "</li>";
      }

      if (tempText.length > 1) category += "\n</random>";


      if (convStart) {  /// if it has no previous box (first text in conversation); make it set the topic
        category += "\n<think><set name=\"topic\">";
        category += topic.toUpperCase();
        category += "</set></think>";
      }

      category += "\n</template>\n</category>\n";
      if (!convStart) category += "</topic>\n";

      aiml += category;  /// add the category to the main String
    }
  }
  aiml += "\n</aiml>";

  String[] list = split(aiml, '\n' );
  saveStrings("../bots/super/aiml/" + topic + ".aiml", list);
}

String fbTagReplace(String txt, boolean template) {
  String returnTxt = "";
  int[] fbStart = new int[1];  // first place is not used, but is neccesary to start the while loop
  int[] fbEnd = new int[1];

  while (fbStart[fbStart.length-1] != -1) {
    fbStart = expand(fbStart, fbStart.length+1);
    fbEnd = expand(fbEnd, fbEnd.length+1);
    fbStart[fbStart.length-1] = txt.indexOf("<", fbEnd[fbEnd.length-2]);
    fbEnd[fbEnd.length-1] = txt.indexOf(">", fbEnd[fbEnd.length-2]+1);
  }
  fbStart[fbStart.length-1] = txt.length();

  if (fbStart.length > 2) {
    returnTxt += txt.substring(0, fbStart[1]);
    for (int i=1; i<fbStart.length-1; i++) {  // first place and last place contain no valid data (0 and -1)
      if (template) {
        returnTxt += "<get name=\"";
        returnTxt += txt.substring(fbStart[i]+1, fbEnd[i]);
        returnTxt += "\"/>";
      }
      else returnTxt += "*";
      returnTxt += txt.substring(fbEnd[i]+1, fbStart[i+1]);
    }
  }
  else {
    returnTxt += txt;
  }

  return returnTxt;
}

