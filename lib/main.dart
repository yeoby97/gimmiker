import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:gimmiker/features/home/home_provider.dart';
import 'package:gimmiker/services/location_service.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'features/home/bottom_sheet/bottom_sheet_provider.dart';
import 'features/main/main_provider.dart';
import 'features/main/main_screen.dart';
import 'features/my_reservation/my_reservation_provider.dart';
import 'features/my_using_space/my_using_space_provider.dart';
import 'features/my_warehouse/my_warehouse_provider.dart';
import 'firebase_options.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async{

  WidgetsBinding binding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: binding);
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);


  final LatLng? location = await findMyLocation();

  FlutterNativeSplash.remove();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MainProvider(location)),
        ChangeNotifierProvider(create: (_) => HomeProvider()),
        ChangeNotifierProvider(create: (_) => BottomSheetProvider()),
        ChangeNotifierProvider(create: (_) => MyWarehouseProvider()),
        ChangeNotifierProvider(create: (_) => MyUsingSpaceProvider()),
        ChangeNotifierProvider(create: (_) => MyReservationProvider()),
      ],
    child: MyApp()
    ),
  );
}

class MyApp extends StatelessWidget {

  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
      ),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('ko', 'KR'),
      ],
      home: const MainScreen(),
    );
  }
}