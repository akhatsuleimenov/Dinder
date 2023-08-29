import 'package:dinder/blocs/auth/bloc/auth_bloc.dart';
import 'package:dinder/repositories/auth_repository.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// import 'blocs/blocs.dart';
// import 'cubits/cubits.dart';
// import 'repositories/repositories.dart';
import 'blocs/swipe/swipe_bloc.dart';
import 'config/theme.dart';
import 'config/app_router.dart';
import 'models/models.dart';
import 'screens/screens.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Start Firebase
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(
          create: (_) => AuthRepository(),
        )
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
              create: (_) =>
                  AuthBloc(authRepository: context.read<AuthRepository>())),
          BlocProvider(
              create: (_) =>
                  SwipeBloc()..add(LoadUsersEvent(users: User.users)))
        ],
        child: MaterialApp(
          title: 'Dinder',
          debugShowCheckedModeBanner: false,
          theme: theme(),
          onGenerateRoute: AppRouter.onGenerateRoute,
          initialRoute: OnboardingScreen.routeName,
        ),
      ),
    );
  }
}
