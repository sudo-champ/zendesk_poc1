import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const ZendeskLauncherScreen(),
    );
  }
}
class ZendeskLauncherScreen extends StatefulWidget {
  const ZendeskLauncherScreen({Key? key}) : super(key: key);

  @override
  State<ZendeskLauncherScreen> createState() => _ZendeskLauncherScreenState();
}

class _ZendeskLauncherScreenState extends State<ZendeskLauncherScreen> {
   MethodChannel? channel;





  @override
  void initState() {
    super.initState();
    channel =  MethodChannel('com.roava.app');
  }

  Future<void> lauchUnifiedSDK() async {
     try {
      final result =  await channel?.invokeMethod("launch_unified");
      print("started $result");
     } catch (e) {
       print("Failed to start zendesk support: ${e.toString()}");
     }
   }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        bottomNavigationBar: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            GestureDetector(
              onTap: () async {
                 await lauchUnifiedSDK();
              },
              child: Container(
                margin: const EdgeInsets.all(20),
                height: 60,
                padding: const EdgeInsets.all(20),
                color: Colors.blue,
                child: const Text("Unified SDK"),
              ),
            ),
            GestureDetector(
              onTap: () {
                print("Chat SDK");
              },
              child: Container(
                margin: const EdgeInsets.all(20),
                height: 60,
                padding: const EdgeInsets.all(20),
                color: Colors.blue,
                child: const Text("Chat SDK V2"),
              ),
            ),
          ],
        ),
        body: const Center(
          child: Text("Zendesk SDK POS"),
        ),
      ),
    );
  }
}
