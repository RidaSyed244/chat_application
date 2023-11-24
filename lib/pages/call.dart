import 'package:flutter/material.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';

class CallPage extends StatefulWidget {
  final String? channelName;
  final ClientRoleOptions? role;
  const CallPage({super.key, this.channelName, this.role});

  @override
  State<CallPage> createState() => _CallPageState();
}

class _CallPageState extends State<CallPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
