import 'dart:io';

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:zoomtest/pages/call/call_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    requestPermissions();
  }

  Map<String, List<Permission>> platformPermissions = {
    "ios": [
      Permission.camera,
      Permission.microphone,
      //Permission.photos,
    ],
    "android": [
      Permission.camera,
      Permission.microphone,
      Permission.bluetoothConnect,
      Permission.phone,
      Permission.storage,
    ],
  };

  Future<void> requestPermissions() async {
    bool blocked = false;
    List<Permission>? notGranted = [];
    List<Permission>? permissions = Platform.isAndroid ? platformPermissions["android"] : platformPermissions["ios"];
    Map<Permission, PermissionStatus>? statuses = await permissions?.request();
    statuses!.forEach((key, status) {
      if (status.isDenied || status.isPermanentlyDenied) {
        blocked = true;
      } else if (!status.isGranted) {
        notGranted.add(key);
      }
    });

    if (notGranted.isNotEmpty) {
      await notGranted.request();
    }

    if (blocked) {
      await openAppSettings();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextButton(
              child: const Text('CALL'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CallScreen(
                      sessionName: 'test1',
                      userName: 'Marian',
                      role: 1,
                    ),
                  ),
                );
              }),
          const SizedBox(height: 20),
          TextButton(
              child: const Text('JOIN'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CallScreen(
                      sessionName: 'test1',
                      userName: 'Olek',
                      role: 0,
                    ),
                  ),
                );
              }),
        ],
      ),
    );
  }
}
