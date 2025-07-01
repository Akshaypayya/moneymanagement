import 'dart:io';

import 'package:flutter/services.dart';
import 'package:growk_v2/core/internet_checker/ui/monitor_connection_view.dart';
import 'package:growk_v2/core/theme/theme_service.dart';
import 'package:growk_v2/views.dart'; // include your app's common views
import 'firebase_options.dart';
import 'package:growk_v2/core/internet_checker/utils/enhanced_internet.dart';
// import 'package:growk_v2/core/internet_checker/view/internet_checker_ui.dart';
import 'package:growk_v2/views.dart';

// final GlobalKey _providerScopeKey = GlobalKey();
class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }
}
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  HttpOverrides.global = MyHttpOverrides();
  WidgetsFlutterBinding.ensureInitialized();

  await SharedPreferencesHelper.init();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // LOCK ORIENTATION TO PORTRAIT
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    // DeviceOrientation.portraitDown, // optionally add this if you want upside-down portrait
  ]);
  final isDark = await ThemeService.loadTheme();
  runApp(ProviderScope(
      overrides: [
        isDarkProvider.overrideWith((ref) => isDark),
      ],
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
    final notificationService = ref.read(notificationProvider);
    notificationService.requestPermission();
    notificationService.firebaseInit(context,ref);
    notificationService.initLocalNotifications(context,ref);
    notificationService.getDeviceToken().then((token) {
      debugPrint('FCM Token: $token');
      SharedPreferencesHelper.saveString('fcm_token', token ?? '');
    });
    Future.microtask(() {
      ref.read(notificationProvider).handleInitialMessage(ref);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScalingFactor(
      child: MaterialApp(
        navigatorKey: navigatorKey,
        debugShowCheckedModeBanner: false,
        title: 'GrowK',
        theme: ThemeData(
          scaffoldBackgroundColor: AppColors.light.background,
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: AppColors.light.primary),
        ),
        onGenerateRoute: AppRouter.generateRoute,
        // builder: (context, child) => EnhancedConnectivityOverlay(
        //   reconnectedDisplayDuration: Duration(milliseconds: 2000),
        //   showConnectionType: true,
        //   showPulseAnimation: true,
        //   child: child ?? const SizedBox(),
        // ),
        builder: (context, child) =>
            MonitorConnectionView(child: child ?? SizedBox()),
      ),
    );
  }
}
