# TallyiOS

[![CI Status](https://img.shields.io/travis/50696559/TallyiOS.svg?style=flat)](https://travis-ci.org/50696559/TallyiOS)
[![Version](https://img.shields.io/cocoapods/v/TallyiOS.svg?style=flat)](https://cocoapods.org/pods/TallyiOS)
[![License](https://img.shields.io/cocoapods/l/TallyiOS.svg?style=flat)](https://cocoapods.org/pods/TallyiOS)
[![Platform](https://img.shields.io/cocoapods/p/TallyiOS.svg?style=flat)](https://cocoapods.org/pods/TallyiOS)


**Getting Started with Tally SDK: A Guide for Businesses and Developers**

### **Introduction to Tally SDK: Revolutionizing Financial Transactions in Your App**

In today's fast-paced digital world, financial transactions and data management require not only robust security but also seamless integration and user-friendly features. The Tally SDK is designed to cater to these needs, offering a suite of features that enhance your app's financial capabilities. This guide introduces the key features of Tally SDK, demonstrating how it can transform the way your app handles financial transactions and data.

### Key Features of Tally SDK

1. **Card Tokenization**: At the heart of secure financial transactions is card tokenization. This feature converts sensitive card information into a secure and encrypted token. This means that actual card details are never stored or transmitted in a way that could be exploited, significantly reducing the risk of fraud.

2. **View the Latest Tokenized Card**: Users can easily access and view the most recently tokenized card, making it convenient to manage and use their preferred payment method without navigating their entire card portfolio.

3. **View All Tokenized Cards**: This feature provides a comprehensive overview of all their cards in one place for users with multiple tokenised cards. It simplifies card management and enhances user experience by offering easy access to their entire tokenized card list.

4. **Save QR Code Image to User's Device Gallery**: This innovative feature allows users to save the QR code of their tokenized card directly to their device's gallery. It's a convenient way to store and retrieve QR codes for payments and transactions without the need for a physical card.

5. **View Transactions from a Single QR (Token)**: Users can view the transaction history associated with a specific QR code or token. This targeted insight into transactions offers a clear and detailed view of spending patterns and transaction details for individual tokens.

6. **View Transaction History from All Tokenized Cards**: For a broader overview, this feature allows users to access the transaction history across all their tokenized cards. It's an essential tool for tracking spending, managing finances, and reviewing transaction details across multiple cards.

7. **View All Merchants and Location on Google Maps**: Enhancing the user experience further, this feature integrates with Google Maps to display merchants and their locations. Users can easily find where their transactions are happening, discover new merchants, and plan their visits accordingly.

### Step 1: Setting Up
To get started, you need to add the Tally SDK to your project. 

## Requirements

## Installation

TallyiOS is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'TallyiOS'
```

## Example

To run the example project, clone the repo and run `pod install` from the Example directory first.


### Step 2: Configuring Your App
Your app needs the right permissions to make full use of Tally SDK's capabilities. Ensure to have added `NSPhotoLibraryAddUsageDescription` to your `info.plist`, else the SDK will crash.

### Step 3: Using the SDK
Integrating Tally SDK into your app's functionality is straightforward. For example, you can add it to a button in your app. When the user clicks this button, the SDK's user interface (UI) will launch, allowing them to interact with financial features securely. Here’s a simple setup to get you started:

```swift
 @IBAction func openTallySDK(){
    let param = TallyParam(userId: "userId", userFullName: "userFullName", userEmail: "userEmail@gmail.com", userPhone: "userPhone", bankName: "bankName", staging: true, apiKey: "apiKey", activationKey: "activationKey")
    param.openTallySdk(controller: self)
    }
```
Replace the parameters with the necessary credentials. This action opens the Tally SDK UI, ready for user interaction.

### Card Tokenization
The Tally SDK offers a secure way to handle card information through tokenization. This process converts sensitive card details into a secure token, minimizing the risk of exposing actual card information.

- **Storing and Encrypting Card Data**: The SDK takes care of encrypting card information and storing it securely, leveraging Keychain. You don't need to manage the complexities of saving to the Keychain. The SDK makes use of Valet to achieve this. To learn more about Valet, [click here](https://github.com/square/Valet) and to learn more about Keychain [click here](https://developer.apple.com/documentation/security/certificate_key_and_trust_services/keys/storing_keys_in_the_keychain)
  
- **Reading Encrypted Data**: To access the stored and encrypted card information, use:
  ```swift
  let tokenizedCardsData = TallDataUtil.shared.retrieveData()
  ```
  This command retrieves the data for you. You will need to check for `nil` as the SDK returns a `nil` value if it can't retrieve data from the keychain.

- **Deleting Information**: If you need to clear stored data, call:
  ```swift
   try TallDataUtil.shared.deleteAllData()
  ```
You need to wrap this in a try-catch.


## Flutter Setup
Open the iOS module of the Flutter project and simply add the following line to your Podfile under the `Runner Target`:

```ruby
pod 'TallyiOS'
```

- **Example**::
```ruby
target 'Runner' do
  use_frameworks!
  use_modular_headers!

  flutter_install_all_ios_pods File.dirname(File.realpath(__FILE__))
  target 'RunnerTests' do
    inherit! :search_paths
  end
  pod 'TallyiOS'
end
```
Run pod install on the iOS folder
Ensure to have added `NSPhotoLibraryAddUsageDescription` to your `info.plist`, else the SDK will crash.

In your AppDelegate file

```swift
import TallyiOS
```
Then call the TallyiOS SDK

```swift



@main
@objc class AppDelegate: FlutterAppDelegate, FlutterStreamHandler {

    // Define the channel identifier
    private let CHANNEL = "com.fundall.gettallysdkui"
    // Define the methods identifier
    private let deleteMethod = "deleteMethod"
    private let fetchMethod = "fetchMethod"
    private let startTallyActivity = "startTallyActivity"
    
    // Declare our eventSink, it will be initialized later
    private var eventSink: FlutterEventSink?

    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        // Set up the MethodChannel with the same name as defined in Dart
        if let flutterViewController = window?.rootViewController as? FlutterViewController {
            let methodChannel = FlutterMethodChannel(name: CHANNEL, binaryMessenger: flutterViewController.binaryMessenger)
            methodChannel.setMethodCallHandler { [weak self] (call: FlutterMethodCall, result: FlutterResult) in
                if call.method == self?.fetchMethod {
                    // Perform platform-specific operations and obtain the result
                    let data = self?.getDataFromTally()

                    // Send the result back to Flutter
                    result(data)
                } else if call.method == self?.deleteMethod {
                    self?.deleteDataFromTally(result: result)
                } else if call.method == self?.startTallyActivity {
                    self?.startSDK(call: call, result: result)
                }else{
                    result(FlutterMethodNotImplemented)
                }
            }

            ///If you prefer event listener you can also retrieve QR codes using event listeners
            //// Use the code below to use eventChannel
         
            let eventChannel = FlutterEventChannel(name: "com.netplus.qrengine.tallysdk/tokenizedCardsData", binaryMessenger: flutterViewController.binaryMessenger)
            eventChannel.setStreamHandler(self)
        }
        
        GeneratedPluginRegistrant.register(with: self)

        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }

   /* func getDataFromTally() -> EncryptedQrModelData? {
        return TallDataUtil.shared.retrieveData()
    }*/
    
    private  func getDataFromTally() -> [String: Any]? {
        
        
        let savedData = TallDataUtil.shared.retrieveData()
      guard let savedData else {
        return nil
      }
       let encoder = JSONEncoder()
    do {
      let data = try encoder.encode(savedData)
     let formattedResponse = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any]
      return formattedResponse
      }catch {
        return nil
      }
    }

    func deleteDataFromTally(result:  FlutterResult) {
        do {
            try TallDataUtil.shared.deleteAllData()
            result("Success")
        }catch let error {
            result(FlutterError(code: "Delete Failed", message: error.localizedDescription, details: nil))
        }
    }
    func startSDK(call: FlutterMethodCall, result:  FlutterResult) {
        if let data = call.arguments as? [String: Any]{
            guard let email = data["email"] as? String else {
                result(FlutterError(code: "INVALID_ARGUMENTS", message: "Enter email", details: nil))
                return
            }
            guard let bankName = data["bankName"] as? String else {
                result(FlutterError(code: "INVALID_ARGUMENTS", message: "Enter bankName", details: nil))
                return
            }
            guard let fullName = data["fullName"] as? String else {
                result(FlutterError(code: "INVALID_ARGUMENTS", message: "Enter fullName", details: nil))
                return
            }
            guard let phoneNumber = data["phoneNumber"] as? String else {
                result(FlutterError(code: "INVALID_ARGUMENTS", message: "Enter phoneNumber", details: nil))
                return
            }
            guard let userId = data["userId"] as? String else {
                result(FlutterError(code: "INVALID_ARGUMENTS", message: "Enter userId", details: nil))
                return
            }
            guard let apiKey = data["apiKey"] as? String else {
                result(FlutterError(code: "INVALID_ARGUMENTS", message: "Enter apiKey", details: nil))
                return
            }
            guard let activationKey = data["activationKey"] as? String else {
                result(FlutterError(code: "INVALID_ARGUMENTS", message: "Enter activationKey", details: nil))
                return
            }
            let param = TallyParam(userId: userId, userFullName: fullName, userEmail: email, userPhone: phoneNumber, bankName: bankName, staging: true, apiKey: apiKey, activationKey: activationKey)
            guard let controller = UIApplication.shared.windows.first?.rootViewController else{
                return
            }
            param.openTallySdk(controller: controller)
        }else{
            result(FlutterError(code: "INVALID_ARGUMENTS", message: "Can't open SDK", details: nil))
        }
    }
    
    func onListen(withArguments arguments: Any?, eventSink: @escaping FlutterEventSink) -> FlutterError? {
        print("onListen......")
        self.eventSink = eventSink
        let dataFetched = getDataFromTally()
        eventSink(dataFetched)
        
    
        return nil
    }
    
    func onCancel(withArguments arguments: Any?) -> FlutterError? {
        eventSink = nil
        return nil
    }
    

}

```
You can convert the response `getDataFromTally` to a JSON/Map<String, dynamic> for uniformity on both Android and iOS
To convert it to Map<String, dynamic> use the code below instead

```swift
private  func getDataFromTally() -> [String: Any]? {
let savedData = TallDataUtil.shared.retrieveData()
      guard let savedData else {
        return nil
      }
       let encoder = JSONEncoder()
    do {
      let data = try encoder.encode(savedData)
     let formattedResponse = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any]
      return formattedResponse
      }catch {
        return nil
      }
    }
```
    
Below is the structure of response to be expected in JSON form

```JSON
{
    "data": [
        {
            "qrcodeId": "1000157614",
            "image": "base 64 string",
            "cardScheme": "cardScheme",
            "issuingBank": "issuingBank",
            "date": "dd MMM YYYY"
           
        }
    ]
}
```


In your Dart(Flutter), add a Function that calls the Native function. We have created a `Dart` class for this use case. It's a simple screen that shows a button, feel free to use your own custome `UI`

```Dart
/// This is an example Flutter application demonstrating how to trigger
/// and receive data from a native SDK using platform channels.
/// 
/// The application consists of a single screen with a button that, when pressed,
/// triggers a native SDK function. The data returned from the native side
/// is then displayed on the screen.
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Trigger SDK Example'),
        ),
        body: const SDKTriggerButton(), // Display the SDK trigger button and the result
      ),
    );
  }
}

class SDKTriggerButton extends StatefulWidget {
  const SDKTriggerButton({super.key});


  @override
  State<SDKTriggerButton> createState() => _SDKTriggerButtonState();
}

class _SDKTriggerButtonState extends State<SDKTriggerButton> {
  static const platformChannel = MethodChannel('com.fundall.gettallysdkui');
  static const EventChannel _eventChannel = EventChannel('com.netplus.qrengine.tallysdk/tokenizedCardsData');


  List<SavedTallyData> savedData = [];

//Toggle this for MethodChannel/EventChannel
  bool useMethod = true;

  @override
  void initState() {

    if (useMethod){
// How to use MethodChannel
      _fetchQRCodesFromTally();
    }else{
// How to use EventChannel
      _tokenizedCardsDataStream.listen((result) {

        if (result != null) {
          _mapData(result);
        }
      });
    }
    super.initState();
  }

  /// Stream to listen for data returned from the native side
  static Stream<dynamic> get _tokenizedCardsDataStream {
    return _eventChannel.receiveBroadcastStream();
  }

  void _fetchQRCodesFromTally() async {
    try {
      final dynamic result = await platformChannel.invokeMethod('fetchMethod');
      if (result != null) {
        _mapData(result);
      }

    } on PlatformException catch (e) {
      if (kDebugMode) {
        print('Error: ${e.message}');
      }
    }
  }

  void _mapData(dynamic result){
    final data = Map<String, dynamic>.from (result as Map);
    List<Map<String, String>> values = [];
    final dataValue = data["data"];
    for (var dt in dataValue){
      values.add(Map<String, String>.from (dt as Map));
    }
    final dataMapped = {"data" : values};

    final fetchedData = SavedTally.fromJson(dataMapped);
    setState(() {
      savedData = fetchedData.data;
    });
  }

  Future<void> _triggerSdkFunction() async {
    try {
      // Invoke the native method to start the SDK activity
      final String result = await platformChannel.invokeMethod('startTallyActivity', {
        // Pass any required arguments to the native method
        "email": "email@example.com",
        "fullName": "John Doe",
        "bankName": "GTBank",
        "phoneNumber": "000000000",
        "userId": "00",
        "activationKey": "activationKey",
        "apiKey": "apiKey"
      });
      if (kDebugMode) {
        print(result);
      } // Print success result from native code
    } on PlatformException catch (e) {
      if (kDebugMode) {
        print("Failed to invoke the method: '${e.message}'.");
      }
    }
  }

  @override
  void dispose() {// Close the stream when disposing.
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () {
            _triggerSdkFunction(); // Call this function when the button is pressed
          },
          child: const Text('Trigger SDK'),
        ),

        Expanded(
          child: Visibility(
            child: cardDetails(savedData)
          ),
        ),

      ],
    );
  }
  
  Widget cardDetails(List<SavedTallyData> savedData){
    return ListView.builder(
      itemCount: savedData.length,
      itemBuilder: (context, position) {
        final data = savedData[position];
        return  Card(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.memory(base64Decode(data.image), height: 120, width: 120,),
                const SizedBox(width: 16,),
                Text(
                  data.issuingBank,
                  style: const TextStyle(fontSize: 22.0),
                ),
              ],
            ),
          ),
        );
      },
    );

  }
}






class SavedTally {
  final List<SavedTallyData> data;

  SavedTally({
    required this.data,
  });

  factory SavedTally.fromJson(Map<String, dynamic> json) => SavedTally(
    data: List<SavedTallyData>.from(json["data"].map((x) => SavedTallyData.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class SavedTallyData {
  final String qrcodeId;
  final String image;
  final String cardScheme;
  final String issuingBank;
  final String date;

  SavedTallyData({
    required this.qrcodeId,
    required this.image,
    required this.cardScheme,
    required this.issuingBank,
    required this.date,
  });

  factory SavedTallyData.fromJson(Map<String, dynamic> json) => SavedTallyData(
    qrcodeId: json["qrcodeId"],
    image: json["image"],
    cardScheme: json["cardScheme"],
    issuingBank: json["issuingBank"],
    date: json["date"],
  );

  Map<String, dynamic> toJson() => {
    "qrcodeId": qrcodeId,
    "image": image,
    "cardScheme": cardScheme,
    "issuingBank": issuingBank,
    "date": date,
  };
}



````

### Conclusion
Integrating Tally SDK into your app not only enhances its financial capabilities but does so with an emphasis on security and ease of use. By following the steps outlined above, developers and business stakeholders alike can ensure a smooth implementation process, bringing sophisticated financial transaction features to your users with minimal hassle. Whether you’re enhancing an existing application or building a new one, Tally SDK provides the tools you need to succeed.


## License

TallyiOS is available under the MIT license. See the LICENSE file for more info.
