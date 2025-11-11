import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'core/theme/app_theme.dart';
import 'core/utils/service_locator.dart';
import 'features/emergency/presentation/pages/home_page.dart';
import 'features/emergency/presentation/bloc/emergency_bloc.dart';
import 'features/contacts/presentation/bloc/contacts_bloc.dart';
import 'features/settings/presentation/bloc/settings_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase
  await Firebase.initializeApp();
  
  // Initialize Hive
  await Hive.initFlutter();
  
  // Initialize dependency injection
  await setupServiceLocator();
  
  runApp(const ShongkotApp());
}

class ShongkotApp extends StatelessWidget {
  const ShongkotApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => getIt<EmergencyBloc>(),
        ),
        BlocProvider(
          create: (context) => getIt<ContactsBloc>()..add(LoadContacts()),
        ),
        BlocProvider(
          create: (context) => getIt<SettingsBloc>()..add(LoadSettings()),
        ),
      ],
      child: MaterialApp(
        title: 'Shongkot Emergency Responder',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        home: const HomePage(),
      ),
    );
  }
}
