// main.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/core/constants/app_colors.dart';
import 'package:flutter_application_1/data/repositories/experience_repository.dart';
import 'package:flutter_application_1/data/services/api_service.dart';
import 'package:flutter_application_1/presentation/screens/experience_selection/bloc/experiance_bloc.dart';
import 'package:flutter_application_1/presentation/screens/experience_selection/bloc/experiance_event.dart';
import 'package:flutter_application_1/presentation/screens/experience_selection/experience_selection_screen.dart';
import 'package:flutter_application_1/presentation/screens/question/bloc/question_bloc.dart';
import 'package:flutter_application_1/presentation/screens/question/question_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Set system UI overlay style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: AppColors.background,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );

  // Lock orientation to portrait
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(
          create: (context) => ExperienceRepository(ApiService()),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => ExperienceBloc(
              repository: context.read<ExperienceRepository>(),
            )..add(LoadExperiences()),
          ),
          BlocProvider(
            create: (context) => QuestionBloc(),
          ),
        ],
        child: MaterialApp(
          title: 'Hotspot Onboarding',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.deepPurple,
            scaffoldBackgroundColor: AppColors.background,
            brightness: Brightness.dark,
            fontFamily: 'Inter', // Add Inter font to pubspec.yaml
          ),
          initialRoute: '/',
          routes: {
            '/': (context) => const ExperienceSelectionScreen(),
            '/question': (context) => const QuestionScreen(),
          },
        ),
      ),
    );
  }
}
