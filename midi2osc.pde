import netP5.*;
import oscP5.*;

import themidibus.*;
import controlP5.*;
import java.util.*;

MidiBus myBus;

ControlP5 cp5;
Slider2D midiMatrix;
Slider abc;
Textlabel setPortLabel, instructions;

int sliderThree=0;
int sliderFour=0;

boolean blockX=false;
boolean blockY=false;
boolean bang01=false;
boolean bang02=false;

OscP5 oscP5;
int[] oscLength;
int[] value;
int port=12345;

Textfield[] address;
Textlabel[] addressLength;
Numberbox[] selectValue;
Textlabel[] valueOsc;

void setup() {
  size(600, 400); 

  //GUI

  cp5=new ControlP5(this);
  cp5.addTab("OSC/MIDI");
  cp5.addTab("Settings");
  cp5.getTab("default")
    .activateEvent(true)
    .setLabel("MIDI")
    .setId(1)
    ;
  cp5.getTab("OSC/MIDI")
    .activateEvent(true)
    .setId(2);
  cp5.getTab("Settings")
    .activateEvent(true)
    .setId(3);

  midiMatrix=cp5.addSlider2D("2D Matrix - Channel 1-2")
    .setPosition(15, 30)
    .setSize(300, 300)
    .setMinMax(0, 0, 127, 127)
    .setValue(0, 0);

  cp5.addToggle("blockX")
    .setPosition(20, 350)
    .setSize(20, 20)
    ;

  cp5.addToggle("blockY")
    .setPosition(80, 350)
    .setSize(20, 20)
    ;
  cp5.addBang("bang01")
    .setLabel("bang01 - Channel 3")
    .setPosition(350, 30)
    .setSize(50, 20)
    .setTriggerEvent(Bang.RELEASE)
    ;
  cp5.addBang("bang02")
    .setLabel("bang01 - Channel 4")
    .setPosition(450, 30)
    .setSize(50, 20)
    .setTriggerEvent(Bang.RELEASE)
    ;

  cp5.addSlider("sliderThree")
    .setLabel("slider 01 - Channel 5")
    .setPosition(350, 70)
    .setSize(200, 40)
    .setRange(0, 127);

  cp5.getController("sliderThree").getCaptionLabel().align(ControlP5.RIGHT, ControlP5.BOTTOM_OUTSIDE).setPaddingX(0);


  cp5.addSlider("sliderFour")
    .setLabel("slider 02 - Channel 6")
    .setPosition(350, 150)
    .setSize(200, 40)
    .setRange(0, 127);

  cp5.getController("sliderFour").getCaptionLabel().align(ControlP5.RIGHT, ControlP5.BOTTOM_OUTSIDE).setPaddingX(0);

  List midiList=Arrays.asList(MidiBus.availableOutputs());

  setPortLabel = cp5.addTextlabel("labelPort")
    .setText("Midi Output Device")
    .setPosition(15, 25);

  instructions = cp5.addTextlabel("instructions")
    .setText("1. Setup the virtual MIDI cable: \n\t For Windows: Download and install loopMIDI http://goo.gl/5wT7MG \n\t For Mac: Read this article http://goo.gl/p0JDd9 \n 2. Restart this program and select the correct MIDI device.")
    .setPosition(15, 350);

  cp5.addScrollableList("midiOutPort")
    .setPosition(15, 40)
    .setSize(200, 100)
    .setBarHeight(20)
    .addItems(midiList);

  cp5.getController("midiOutPort").moveTo("Settings");
  cp5.getController("labelPort").moveTo("Settings");
  cp5.getController("instructions").moveTo("Settings");
  oscLength=new int[5];
  value=new int[5];
  address= new Textfield[5];
  addressLength= new Textlabel[5];
  selectValue=new Numberbox[5];
  valueOsc=new Textlabel[5];
  for (int i=0; i<oscLength.length; i++) {
    address[i]=cp5.addTextfield("address0"+i)
      .setLabel("address 0"+i+" -  channel "+(i+7))
      .setPosition(20, (i*40)+30)
      .setAutoClear(false)
      ;
    oscLength[i]=0;
    addressLength[i]=cp5.addLabel("Length "+i+": "+oscLength[i])
      .setPosition(250, (i*40)+35);
    
    selectValue[i]=cp5.addNumberbox("value "+i)
                      .setPosition(350, (i*40)+35)
                      .setScrollSensitivity(1)
                      .setMax(0)
                      .setMin(0);
    value[i]=0;
    valueOsc[i]=cp5.addLabel("result "+i+": "+value[i])
                    .setPosition(450, (i*40)+35);
    
    cp5.getController("address0"+i).moveTo("OSC/MIDI");
    cp5.getController("Length "+i+": "+oscLength[i]).moveTo("OSC/MIDI");
    cp5.getController("value "+i).moveTo("OSC/MIDI");
    cp5.getController("result "+i+": "+value[i]).moveTo("OSC/MIDI");
  }

  cp5.addTextfield("OSCport")
    .setLabel("OSC port")
    .setPosition(400, 40)
    .setText(""+port)
    .setSize(100, 20);

  cp5.addBang("connect")
    .setPosition(520, 40)
    .setSize(20, 20);

  cp5.getController("OSCport").moveTo("Settings");
  cp5.getController("connect").moveTo("Settings");

  //MIDI

  myBus=new MidiBus(this, -1, 1);

  //OSC

  oscP5 = new OscP5(this, port);
}
void draw() {
  background(0);
  noStroke();
  fill(50);
  rect(0, 15, width, height-15);
  //SLIDER 01
  if (cp5.getController("sliderThree").isMousePressed()) {
    myBus.sendNoteOn(2, sliderThree, 127);
  }
  //SLIDER 02
  if (cp5.getController("sliderFour").isMousePressed()) {
    myBus.sendNoteOn(3, sliderFour, 127);
  }
  //SLIDER 2D
  if (cp5.getController("2D Matrix - Channel 1-2").isMousePressed()) {
    if (blockX==false) {
      myBus.sendNoteOn(0, int(midiMatrix.getArrayValue()[0]), 127);
    }
    if (blockY==false) {
      myBus.sendNoteOn(1, int(midiMatrix.getArrayValue()[1]), 127);
    }
  }
  //TOGGLE 01
  if (cp5.getController("bang01").isMousePressed()) {
    if (bang01==true) {
      myBus.sendNoteOn(4, 127, 127);
      delay(500);
      myBus.sendNoteOff(4, 127, 127);
    }
  }
  //TOGGLE 01
  if (cp5.getController("bang02").isMousePressed()) {
    if (bang02==true) {
      myBus.sendNoteOn(5, 127, 127);
      delay(500);
      myBus.sendNoteOff(5, 127, 127);
    }
  }
  
}

void controlEvent(ControlEvent theControlEvent) {
  
}
void oscEvent(OscMessage theOscMessage) {
  print("### received an osc message.");
  print(" addrpattern: "+theOscMessage.addrPattern());
  println(" typetag: "+theOscMessage.arguments().length);
  for (int i=0; i<oscLength.length; i++) {
    if (theOscMessage.checkAddrPattern(address[i].getText())==true) {
      oscLength[i]=theOscMessage.arguments().length;
      addressLength[i].setText("Length "+i+": "+oscLength[i]);
      selectValue[i].setMax(oscLength[i]);
      selectValue[i].setMin(1);
      valueOsc[i].setText("result "+i+": "+theOscMessage.get(int(selectValue[i].getValue())).floatValue());
    }
  }
}
void midiOutPort() {
  myBus=new MidiBus(this, -1, int(cp5.get(ScrollableList.class, "midiOutPort").getValue()));
}

void connect() {
  oscP5 = new OscP5(this, int(cp5.getController("OSCport").getStringValue()));
}
void delay(int time) {
  int current = millis();
  while (millis () < current+time) Thread.yield();
}