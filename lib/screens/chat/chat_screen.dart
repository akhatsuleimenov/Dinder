import 'package:dinder/repositories/repositories.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/widgets/widgets.dart';
import '/blocs/blocs.dart';
import '/models/models.dart';

class ChatScreen extends StatelessWidget {
  static const String routeName = '/chat';

  static Route route({required Match match}) {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (context) => BlocProvider<ChatBloc>(
        create: (context) => ChatBloc(
          databaseRepository: context.read<DatabaseRepository>(),
        )..add(
            LoadChat(match.chat.id),
          ),
        child: ChatScreen(match: match),
      ),
    );
  }

  final Match match;

  const ChatScreen({
    super.key,
    required this.match,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _CustomAppBar(match: match),
      bottomNavigationBar: const CustomBottomBar(),
      body: BlocBuilder<ChatBloc, ChatState>(
        builder: (context, state) {
          if (state is ChatLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is ChatLoaded) {
            return Column(
              children: [
                ListView.builder(
                  reverse: true,
                  shrinkWrap: true,
                  itemCount: state.chat.messages.length,
                  itemBuilder: (context, index) {
                    List<Message> messages = state.chat.messages;
                    return ListTile(
                      title: _Message(
                        message: messages[index].message,
                        isFromCurrentUser: messages[index].senderId ==
                            context.read<AuthBloc>().state.authUser!.uid,
                      ),
                    );
                  },
                ),
                const Spacer(),
                _MessageInput(match: match),
              ],
            );
          } else {
            return const Center(
              child: Text("error"),
            );
          }
        },
      ),
    );
  }
}

class _MessageInput extends StatelessWidget {
  const _MessageInput({
    required this.match,
  });

  final Match match;

  @override
  Widget build(BuildContext context) {
    TextEditingController controller = TextEditingController();
    return Container(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Theme.of(context).primaryColor,
            ),
            child: IconButton(
              icon: const Icon(Icons.send_outlined),
              onPressed: () {
                context.read<ChatBloc>().add(
                      AddMessage(
                        userId: match.userId,
                        matchUserId: match.matchUser.id!,
                        message: controller.text,
                      ),
                    );
                controller.clear();
              },
              color: Colors.white,
            ),
          ),
          Expanded(
            child: TextField(
              controller: controller,
              decoration: const InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hintText: 'Type here...',
                contentPadding: EdgeInsets.only(left: 20, bottom: 5, top: 5),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Message extends StatelessWidget {
  const _Message({
    required this.message,
    required this.isFromCurrentUser,
  });

  final String message;
  final bool isFromCurrentUser;

  @override
  Widget build(BuildContext context) {
    AlignmentGeometry alignment =
        isFromCurrentUser ? Alignment.topRight : Alignment.topLeft;

    Color color = isFromCurrentUser
        ? Theme.of(context).shadowColor
        : Theme.of(context).primaryColor;

    TextStyle? textStyle = isFromCurrentUser
        ? Theme.of(context).textTheme.headlineSmall
        : Theme.of(context)
            .textTheme
            .headlineSmall!
            .copyWith(color: Colors.white);

    return Align(
      alignment: alignment,
      child: Container(
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          color: color,
        ),
        child: Text(
          message,
          style: textStyle,
        ),
      ),
    );
  }
}

class _CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const _CustomAppBar({
    required this.match,
  });

  final Match match;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).shadowColor,
      elevation: 0,
      iconTheme: IconThemeData(
        color: Theme.of(context).primaryColor,
      ),
      title: Column(
        children: [
          InkWell(
            onDoubleTap: () {
              Navigator.pushNamed(context, '/users',
                  arguments:
                      ScreenArguments(user: match.matchUser, action: false));
            },
            child: CircleAvatar(
              radius: 15,
              backgroundImage: NetworkImage(match.matchUser.imageUrls[0]),
            ),
          ),
          Text(
            match.matchUser.name,
            style: Theme.of(context).textTheme.headlineLarge,
          )
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(56.0);
}
