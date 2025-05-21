import 'dart:io';

import 'package:money_mangmnt/views.dart';

// final GlobalKey _providerScopeKey = GlobalKey();
class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

Future<void> main() async {
  HttpOverrides.global = MyHttpOverrides();
  ScaledWidgetsFlutterBinding.ensureInitialized(
    scaleFactor: (deviceSize) {
      const double widthOfDesign = 435;
      return deviceSize.width / widthOfDesign;
    },
  );
  await SharedPreferencesHelper.init();

  // await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // await SharedPreferencesHelper.init();

  // SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  // SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
  //   statusBarColor: Colors.transparent,
  //   systemNavigationBarColor: Colors.transparent,
  //   systemStatusBarContrastEnforced: false,
  //   systemNavigationBarContrastEnforced: false,
  //   statusBarBrightness: Brightness.dark,
  //   statusBarIconBrightness: Brightness.dark,
  //   systemNavigationBarIconBrightness: Brightness.dark,
  //   systemNavigationBarDividerColor: Colors.black,
  // ));

  runApp(ProviderScope(
      // key: _providerScopeKey,
      child: MyApp()));
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  @override
  void initState() {
    super.initState();
    // final notificationService = ref.read(notificationProvider);
    //
    // notificationService.requestPermission();
    // notificationService.firebaseInit(context);
    // notificationService.initLocalNotifications(context);
    // notificationService.getDeviceToken().then((token) {
    //   debugPrint('FCM Token: $token');
    //   SharedPreferencesHelper.saveString('fcm_token', token ?? '');
    // });
  }

  @override
  Widget build(BuildContext context) {
    return ScalingFactor(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'GrowK',
        theme: ThemeData(
          scaffoldBackgroundColor: AppColors.light.background,
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: AppColors.light.primary),
        ),
        onGenerateRoute: AppRouter.generateRoute,
      ),
    );
  }
}
