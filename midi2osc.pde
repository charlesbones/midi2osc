import themidibus.*;
import controlP5.*;
import java.util.*;

MidiBus myBus;
String[] midiPort;

ControlP5 cp5;
Slider2D midiMatrix;
Slider midiSlider00, midiSlider01;
Textlabel setPortLabel;

int idTab=1;

void setup() {
  size(600, 400); 

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

  midiMatrix=cp5.addSlider2D("2D Matrix - Channel 0")
    .setPosition(15, 30)
    .setSize(300, 300)
    .setMinMax(0, 0, 127, 127)
    .setValue(0, 0);

  cp5.addToggle("toggle01 - Channel 1")
    .setPosition(350, 30)
    .setSize(50, 20)
    .setValue(true)
    .setMode(ControlP5.SWITCH)
    ;
  cp5.addToggle("toggle 02 - Channel 2")
    .setPosition(450, 30)
    .setSize(50, 20)
    .setValue(true)
    .setMode(ControlP5.SWITCH)
    ;

  cp5.addSlider("sliderThree")
    .setLabel("slider 01 - Channel 3")
    .setPosition(350, 70)
    .setSize(200, 40)
    .setRange(0, 127);

  cp5.getController("sliderThree").getCaptionLabel().align(ControlP5.RIGHT, ControlP5.BOTTOM_OUTSIDE).setPaddingX(0);


  cp5.addSlider("slider 02 - Channel 4")
    .setPosition(350, 150)
    .setSize(200, 40)
    .setRange(0, 127);

  cp5.getController("slider 02 - Channel 4").getCaptionLabel().align(ControlP5.RIGHT, ControlP5.BOTTOM_OUTSIDE).setPaddingX(0);

  List midiList=Arrays.asList(MidiBus.availableOutputs());

  setPortLabel = cp5.addTextlabel("labelPort")
    .setText("Midi Output Device")
    .setPosition(15, 25);

  cp5.addScrollableList("midiOutPort")
    .setPosition(15, 40)
    .setSize(200, 100)
    .setBarHeight(20)
    .addItems(midiList);

  cp5.getController("midiOutPort").moveTo("Settings");
  cp5.getController("labelPort").moveTo("Settings");

  myBus=new MidiBus(this, -1, 0);
}
void draw() {
  background(0);
  noStroke();
  fill(50);
  rect(0, 15, width, height-15);
}
void controlEvent(ControlEvent theControlEvent) {
  if (theControlEvent.isTab()) {
    println("got an event from tab : "+theControlEvent.getTab().getName()+" with id "+theControlEvent.getTab().getId());
    idTab=theControlEvent.getTab().getId();
  }
}
void midiOutPort() {
  myBus=new MidiBus(this, -1, int(cp5.get(ScrollableList.class, "midiOutPort").getValue()));
}
void midiMatrix() {
  myBus.sendNoteOn(0, 0, int(midiMatrix.getArrayValue()[0]));
  myBus.sendNoteOn(1, 1, int(midiMatrix.getArrayValue()[1]));
  println("hola");
}
void sliderThree(){
 println("slide"); 
}