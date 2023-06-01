import 'package:flutter/material.dart';

import 'package:flutter_tawk/flutter_tawk.dart';

class Chat extends StatefulWidget {
  const Chat({super.key});

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Cahtting'),
        backgroundColor: Color(0xfff7b858),
        elevation: 0,
      ),
      body: Tawk(
        directChatLink:
            'https://tawk.to/chat/6478f6f374285f0ec46f0762/1h1s89anv',
        visitor: TawkVisitor(
          name: 'yazan alsade',
          email: 'yazanalsade327@gmail.com',
        ),
        onLoad: () {
          print('Hello Tawk!');
        },
        onLinkTap: (String url) {
          print(url);
        },
        placeholder: const Center(
          child: Text('Loading...'),
        ),
      ),
    );
  }
}
