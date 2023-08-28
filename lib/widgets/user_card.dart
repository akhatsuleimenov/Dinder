import 'package:dinder/models/user_model.dart';
import 'package:flutter/material.dart';

class UserCard extends StatelessWidget {
  final User user;

  const UserCard({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'user_image',
      child: Padding(
        padding: const EdgeInsets.only(
          top: 20,
          left: 20,
          right: 20,
        ),
        child: SizedBox(
          height: MediaQuery.of(context).size.height / 1.5,
          width: MediaQuery.of(context).size.width,
          child: Stack(children: [
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage(user.imageUrls[0]),
                ),
                borderRadius: BorderRadius.circular(5.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 4,
                    blurRadius: 4,
                    offset: Offset(3, 3),
                  )
                ],
              ),
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5.0),
                gradient: LinearGradient(
                  colors: [
                    Color.fromARGB(200, 0, 0, 0),
                    Color.fromARGB(0, 0, 0, 0),
                  ],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                ),
              ),
            ),
            Positioned(
              left: 10,
              bottom: 30,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${user.name}, ${user.age}',
                    style: Theme.of(context)
                        .textTheme
                        .displayLarge
                        ?.copyWith(color: Colors.white),
                  ),
                  Text(
                    user.major,
                    style: Theme.of(context).textTheme.displayMedium?.copyWith(
                        color: Colors.white, fontWeight: FontWeight.normal),
                  ),
                ],
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
