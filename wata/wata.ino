int moistureSensor = 1;
void setup() {
  // put your setup code here, to run once:
  Serial.begin(9600);
}

void loop() {
  // put your main code here, to run repeatedly:

	// api request
  int moistureVal = analogRead(moistureSensor);
  Serial.print(moistureVal);
  Serial.println();
	// check if reached == true
	// put a delay here for like 20s or something
}
