import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  static const String routeName = '/chat';

  static Route route() {
    return MaterialPageRoute(
      builder: (context) => ChatScreen(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
