#pragma region includes

#include <BLEDevice.h>
#include <BLEServer.h>
#include <Ticker.h>
#include <Adafruit_MPU6050.h>

#pragma endregion


#pragma region defines

#define BLE_SERVICE_UUID "f6467fe0-3af7-4bdb-b5a5-4c9a5dec1568"
#define SEND_DATA_CHARACTERISTIC_UUID "6623079c-f1e4-433a-8bb6-d78c713eb51c"

#define INDICADOR_PIN 36
#define DEDO_MEIO_PIN 39
#define ANULAR_PIN 34
#define MINDINHO_PIN 35
#define POLEGAR_PIN 32

#define LED_PIN 2


#pragma endregion

#pragma region mpu_variables

Adafruit_MPU6050 mpu;

int16_t ax, ay, az;
int16_t gx, gy, gz;

char *axStr, *ayStr, *azStr;
char *gxStr, *gyStr, *gzStr;

#pragma endregion

#pragma region ble_variables

BLEServer *pServer = NULL;

BLECharacteristic *sendDataCharacteristic = NULL;
bool isBLEConnected = false;

#pragma endregion

Ticker ticker;

void changeLed() {digitalWrite(LED_PIN, !digitalRead(LED_PIN));}


//stop ble server
void stopBLE()
{
  BLEDevice::stopAdvertising();
  BLEDevice::deinit(true);
}


// ble server callbacks
class MyBLEServerCallbacks : public BLEServerCallbacks
{
  void onConnect(BLEServer *pServer)
  {
    Serial.println("Bluetooth Connected");
    isBLEConnected = true;
    ticker.detach();
    digitalWrite(LED_PIN, LOW);
  }

  void onDisconnect(BLEServer *pServer)
  {
    digitalWrite(LED_PIN, HIGH);
    Serial.println("Bluetooth Disconnected");
    isBLEConnected = false;

    delay(1000);
    BLEDevice::startAdvertising();
    Serial.println("Waiting a client connection to notify...");
    ticker.attach(0.3, changeLed);
  }
};


//init ble server and its characteristics
void initBLE()
{
  //init ble
  BLEDevice::init("ESP32_LUVA");

  //create server
  pServer = BLEDevice::createServer();
  pServer->setCallbacks(new MyBLEServerCallbacks());

  //create the service
  BLEService *pService = pServer->createService(BLE_SERVICE_UUID);

  //create characteristic
  sendDataCharacteristic = pService->createCharacteristic(SEND_DATA_CHARACTERISTIC_UUID, BLECharacteristic::PROPERTY_NOTIFY);


  // Start the service
  pService->start();

  // Start advertising
  BLEAdvertising *pAdvertising = BLEDevice::getAdvertising();
  pAdvertising->addServiceUUID(BLE_SERVICE_UUID);
  BLEDevice::startAdvertising();
  Serial.println("Waiting a client connection to notify...");
  ticker.attach(0.3, changeLed);

}


void setup()
{
  pinMode(LED_PIN, OUTPUT);
  digitalWrite(LED_PIN, HIGH);

  Serial.begin(115200);

  delay(1000);

  if(mpu.begin()) Serial.println("MPU6050 connection successful");
  
  else Serial.println( "MPU6050 connection failed");
  
  initBLE();
    
}

void loop()
{
  if(isBLEConnected)
  {
    sensors_event_t a, g, temp;
    mpu.getEvent(&a, &g, &temp);

    char jsonBuffer[90];

    sprintf(jsonBuffer, "{\"flex\":[%d,%d,%d,%d,%d],\"aceleracao\":[%.2f,%.2f,%.2f]}",
      analogRead(POLEGAR_PIN),
      analogRead(INDICADOR_PIN),
      analogRead(DEDO_MEIO_PIN),
      analogRead(ANULAR_PIN),
      analogRead(MINDINHO_PIN),
      a.acceleration.x,
      a.acceleration.y,
      a.acceleration.z
    );
    
    sendDataCharacteristic->setValue(jsonBuffer);
    sendDataCharacteristic->notify();

    delay(10);
  }
}
