

#include <LiquidCrystal.h>


const int testLedPin = 13;      // the pin that the LED is attached to

// LCDs
LiquidCrystal lcd1(52, 53,50,51,48,49);
LiquidCrystal lcd2(45, 44,43,42,41,40);
//ENCODERS;
int encoder1A = 2;  // pin 12
int encoder1B = 3;  // pin 11
int encoder1AValue;  // pin 12
int encoder1BValue;  // pin 11
int enconder1Counter=0;
//BUTTONS
int gearSwitch = 28;     // the number of the pushbutton pin
//LEDS
int ledLeftGearDown=32;
int ledLeftGearTransit=33;
int ledCenterGearTransit=35;
int ledCenterGearDown=34;
int ledRightGearTransit=37;
int ledRightGearDown=36;


//SIM VARS
byte gear1Position;
byte gear2Position;
byte gear3Position;
int planeIASValue = 0;
int planeAltValue    = 0;
int planePitchValue   = 0;
int planeRollValue   = 0;
int planeHeadingValue = 0;
int planeVSpeedValue=0;
//INPUTS
int gearSwitchValue;

//time
long time;
long lcdLastRefresh;
const int lcdRefreshInterval=100; //millis
 
void setup()
{
  //LCDS
  // set up the LCD's number of columns and rows: 
  lcd1.begin(16, 2);
  lcd2.begin(20, 4);
  
  //ENCODERS
  pinMode(encoder1A, INPUT);
  pinMode(encoder1B, INPUT);
  
  //INTERRUPTIONS
  attachInterrupt(0, rise, RISING);  
   
  // LEDS
  pinMode(testLedPin, OUTPUT);
  pinMode(ledLeftGearDown, OUTPUT);
  pinMode(ledLeftGearTransit, OUTPUT);
  pinMode(ledCenterGearTransit, OUTPUT);
  pinMode(ledCenterGearDown, OUTPUT);
  pinMode(ledRightGearTransit, OUTPUT);
  pinMode(ledRightGearDown, OUTPUT);
  
  //SWITCHES
  pinMode(gearSwitch, INPUT); 
 
   // initialize the serial communication:
  Serial.begin(9600);
  
  testGearsLeds();

  
  time = millis();
  lcdLastRefresh=time;
}
void rise(){
  encoder1AValue=digitalRead(encoder1A);
  encoder1BValue=digitalRead(encoder1B);
  if(encoder1AValue && encoder1BValue){
    enconder1Counter++;  
  }else{
    enconder1Counter--;
  }
  
}



void loop() {
  
  
  time = millis();
  
  //READ PANEL INPUTS
  gearSwitchValue = !digitalRead(gearSwitch);
  
  //DISPLAY INFO
  int dif=millis()-lcdLastRefresh;
  if(dif>lcdRefreshInterval){
      lcdLastRefresh=millis();
      lcd1.clear();    
      //lcd2.clear();
    
      lcd2.setCursor(0,0);
      lcd2.print ("Spd");
      lcd2.setCursor(4,0);
      lcd2.print (formatNumberLength(planeIASValue,4));
          
      lcd2.setCursor(9,0);
      lcd2.print ("Alt");
      lcd2.setCursor(13,0);
      lcd2.print (formatNumberLength(planeAltValue,5));
      
      lcd2.setCursor(0,1);
      lcd2.print ("Hdg");
      lcd2.setCursor(4,1);
      lcd2.print (formatNumberLength(planeHeadingValue,3));
      
      lcd2.setCursor(8,1);
      lcd2.print ("VSpd");
      lcd2.setCursor(13,1);
      lcd2.print (formatNumberLength(planeVSpeedValue,5));
      
      lcd2.setCursor(0,2);
      lcd2.print ("Pitch");
      lcd2.setCursor(6,2);
      lcd2.print (formatNumberLength(planePitchValue,3));
      
      lcd2.setCursor(10,2);
      lcd2.print ("Roll");
      lcd2.setCursor(15,2);
      lcd2.print (formatNumberLength(planeRollValue,4));  
   }
   
   //GEAR LEDS
  if(gearSwitchValue){//SWITCH DOWN (1)
     if(gear1Position==255){
          digitalWrite(ledCenterGearTransit, LOW);  
          digitalWrite(ledCenterGearDown, HIGH);  
      }else{
         digitalWrite(ledCenterGearTransit, HIGH);  
          digitalWrite(ledCenterGearDown, LOW);  
      }
      
       if(gear2Position==255){
          digitalWrite(ledLeftGearTransit, LOW);  
          digitalWrite(ledLeftGearDown, HIGH);  
      }else{
         digitalWrite(ledLeftGearTransit, HIGH);  
          digitalWrite(ledLeftGearDown, LOW);  
      }
      
      if(gear3Position==255){
          digitalWrite(ledRightGearTransit, LOW);  
          digitalWrite(ledRightGearDown, HIGH);  
      }else{
         digitalWrite(ledRightGearTransit, HIGH);  
          digitalWrite(ledRightGearDown, LOW);  
      }
  }else{//SWITCH UP (0)     
     digitalWrite(ledCenterGearDown, LOW); 
    if(gear1Position==0){   
        digitalWrite(ledCenterGearTransit, LOW);  
    }else{
       digitalWrite(ledCenterGearTransit, HIGH);  
    }
    digitalWrite(ledLeftGearDown, LOW); 
    if(gear2Position==0){   
        digitalWrite(ledLeftGearTransit, LOW);  
    }else{
       digitalWrite(ledLeftGearTransit, HIGH);  
    }
    digitalWrite(ledRightGearDown, LOW); 
    if(gear3Position==0){   
        digitalWrite(ledRightGearTransit, LOW);  
    }else{
       digitalWrite(ledRightGearTransit, HIGH);  
    }
    
  }
    
}

void serialEvent() {
  
  // check if data has been sent from the computer:
  if (Serial.available()) {
   
    // read the most recent byte (which will be from 0 to 255):
    gear1Position =readByte();
    gear2Position = readByte(); 
    gear3Position = readByte();
    planePitchValue=readInt();
    planeRollValue=readInt();
    planeHeadingValue=readInt();
    planeIASValue=readInt();
    planeAltValue=readInt();
    planeVSpeedValue=readInt();
    
    while (Serial.available()) {
       //FLUSH 
       Serial.read(); 
    }
    // set the brightness of the LED:
    Serial.write(gearSwitchValue);
  }
}


void testGearsLeds(){
    digitalWrite(ledLeftGearDown, LOW); 
     delay(100);
     digitalWrite(ledLeftGearDown, HIGH); 
     delay(100);
     digitalWrite(ledLeftGearDown, LOW); 
     
      digitalWrite(ledLeftGearTransit, LOW); 
     delay(100);
     digitalWrite(ledLeftGearTransit, HIGH); 
     delay(100);
     digitalWrite(ledLeftGearTransit, LOW); 
     

      digitalWrite(ledCenterGearDown, LOW); 
     delay(100);
     digitalWrite(ledCenterGearDown, HIGH); 
     delay(100);
     digitalWrite(ledCenterGearDown, LOW); 
     
     digitalWrite(ledCenterGearTransit, LOW); 
     delay(100);
     digitalWrite(ledCenterGearTransit, HIGH); 
     delay(100);
     digitalWrite(ledCenterGearTransit, LOW); 
     
     
     
      digitalWrite(ledRightGearDown, LOW); 
     delay(100);
     digitalWrite(ledRightGearDown, HIGH); 
     delay(100);
     digitalWrite(ledRightGearDown, LOW); 
    
     
      digitalWrite(ledRightGearTransit, LOW); 
     delay(100);
     digitalWrite(ledRightGearTransit, HIGH); 
     delay(100);
     digitalWrite(ledRightGearTransit, LOW); 
}

String formatNumberLength(int number,int length){
  String aux=String(number);
  if(aux[0] == '-'){
     aux=aux.substring(1,aux.length());
     while(aux.length()<length-1){
       aux="0"+aux;
    }
    return "-"+aux;
  }else{
    while(aux.length()<length){
       aux="0"+aux;
    }
     return aux;
  }
  
}

byte readByte(){
    while(!Serial.available()) ;
    return Serial.read();
      
}
int readInt(){
  while(!Serial.available()) ;
   int value=Serial.read();
   while(!Serial.available()) ;
   value+=(256*Serial.read());
    return value;
}


