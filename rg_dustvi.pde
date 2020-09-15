// at the top of the program:
float xPos = 0; // horizontal position of the graph
float yPos = 0; // vertical position of the graph
int inByte; // read serial port
String inString = "12,3"; // read serial port string
boolean newdata = false;
int startingX = -1;
float yMod = 5; //20;
float xMod = .33; // how seconds need to be modified to fit into 1200 pixels = 1 hour
float yOld = 0;
import processing.serial.*;
Serial myPort;        // The serial port
  
void setup () {
  size(1400, 600);        // (Width, Height) window size
  // List all the available serial ports
  println(Serial.list());
  
  String portName = Serial.list()[1];
  myPort = new Serial(this, portName, 9600);
  myPort.bufferUntil('\n');
  
  background(#000000);
}
  
void draw () {
   // draw the line in a pretty color:
  if (newdata) { // only proceed if you have new data
      stroke(#A8D9A7);
      line(xPos, height, xPos+1, yPos); // (x1,y1,x2,y2) Origin located at top left corner
      ellipse(xPos, yPos, 10,10);
  /* xPos is handled inside serialEvent
  // at the edge of the screen, go back to the beginning:
  if (xPos >= width) {
    xPos = 0;
    // clear the screen by resetting the background:
    background(#081640);
  }
  else {
    // increment the horizontal position for the next reading:
    xPos++;
  }
  */

      // print the number and time in the top left
        stroke(#000000); fill(#000000);
        rect(0,0,200,20);
        stroke(#FFFFFF); fill(#FFFFFF);
        text(inString, 10, 15);
        // draw annotation if y-value has changed
        if (abs(yOld-yPos)>20) { // pixels of diff
          text(inString,xPos+5-80,yPos-5);
          yOld = yPos;
        }
        newdata = false;
    }
}
  
void serialEvent (Serial myPort) {

  // get the string
  inString = myPort.readString(); // buffering to \n
  
  if(inString != null) {
    // println(inString); // raw string
    inString=trim(inString);
    if(split(inString,",").length>1)  // correctly formatted string?
    {
      if (startingX < 0) startingX = int(split(inString,',')[0]); // if startingX is uninitialized take 
      
      xPos =xMod*(float(split(inString,',')[0])-startingX)/1000;
      // xPos=(xPos/1000)*xMod; // convert to elapsed seconds. if a pixel = a second then you'll have 1200/
      println("_______" + xPos + ", startingX = " + startingX);

      // sometimes xPos is negative so if this happens reset xPos
      if (xPos<0) startingX = int(split(inString,',')[0]);
      yPos = height - yMod*float(split(inString,',')[1]);
      
      println(xPos + ", " + yPos);  // coordinates
      newdata = true; // flip so we know to graph this
    }
  }
}