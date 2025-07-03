import 'dart:io';
import 'package:flutter/services.dart';
import 'package:growk_v2/core/constants/app_texts_string.dart';
import 'package:growk_v2/core/constants/common_providers.dart';
import 'package:growk_v2/core/internet_checker/ui/monitor_connection_view.dart';
import 'package:growk_v2/core/theme/theme_service.dart';
import 'package:growk_v2/features/settings_page/widgets/settings_item.dart';
import 'package:growk_v2/views.dart'; // include your app's common views
import 'firebase_options.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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

  ScaledWidgetsFlutterBinding.ensureInitialized(
    scaleFactor: (deviceSize) {
      const double widthOfDesign = 435;
      return deviceSize.width / widthOfDesign;
    },
  );

  await SharedPreferencesHelper.init();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  final isDark = await ThemeService.loadTheme();
  final isNotificationsEnabled = SharedPreferencesHelper.getBool('notifications_enabled') ?? true;

  runApp(
    ProviderScope(
      overrides: [
        isDarkProvider.overrideWith((ref) => isDark),
        notificationEnabledProvider.overrideWith((ref) => isNotificationsEnabled),
        appTextsProvider.overrideWith((ref) => AppTextsString.empty()),
      ],
      child: const MyApp(),
    ),
  );
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
    final isNotificationEnabled = ref.read(notificationEnabledProvider);

    if (isNotificationEnabled) {
      debugPrint('🔔 Notifications are enabled. Initializing Firebase services.');
      notificationService.requestPermission();
      notificationService.initLocalNotifications(context, ref);
      notificationService.firebaseInit(context, ref);
      notificationService.getDeviceToken().then((token) {
        debugPrint('🔑 FCM Token: $token');
        SharedPreferencesHelper.saveString('fcm_token', token ?? '');
      });
      Future.microtask(() {
        notificationService.handleInitialMessage(ref, context);
      });
    } else {
      debugPrint('🔕 Notifications are disabled. Skipping Firebase initialization.');
    }
  }

  @override
  Widget build(BuildContext context) {
    final locale = ref.watch(localeProvider);
    return ScalingFactor(
      child: MaterialApp(
        locale: locale,
        supportedLocales: AppLocalizations.supportedLocales,
        localeResolutionCallback: (locale, supportedLocales) {
          for (var supportedLocale in supportedLocales) {
            if (supportedLocale.languageCode == locale?.languageCode) {
              return supportedLocale;
            }
          }
          return supportedLocales.first;
        },
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        navigatorKey: navigatorKey,
        debugShowCheckedModeBanner: false,
        title: 'GrowK',
        theme: ThemeData(
          scaffoldBackgroundColor: AppColors.light.background,
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: AppColors.light.primary),
        ),
        onGenerateRoute: AppRouter.generateRoute,
        builder: (context, child) {
          final localizations = AppLocalizations.of(context)!;

          WidgetsBinding.instance.addPostFrameCallback((_) {
            ref.read(appTextsProvider.notifier).state = AppTextsString(localizations);
          });

          return MonitorConnectionView(child: child ?? const SizedBox());
        },

      ),
    );
  }
}
