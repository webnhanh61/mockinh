/**
 * Tên file: main.dart 
 * Tên tác giả: La Văn Thanh
 * Mô tả: Khởi tạo ứng dụng, cấu hình Hive, MultiProvider và khởi tạo lõi Thông báo (NotificationHelper). Đã bổ sung PracticeProvider để quản lý tu tập. [WEBVNZ.COM]
 */
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';

// Import Providers
import 'providers/settings_provider.dart';
import 'providers/bookmark_provider.dart';
import 'providers/reading_history_provider.dart';
import 'providers/practice_provider.dart';

// Import các màn hình
import 'ui/screens/main_screen.dart';
import 'ui/screens/reader_screen.dart';

// Import cấu hình thông báo
import 'utils/notification_helper.dart';

void main() async {
  // Đảm bảo Flutter core đã sẵn sàng trước khi gọi các hàm native
  WidgetsFlutterBinding.ensureInitialized();

  // Khởi tạo cơ sở dữ liệu cục bộ Hive
  await Hive.initFlutter();

  // Khởi tạo hệ thống thông báo và múi giờ khi app vừa mở lên
  await NotificationHelper.init();

  // Thiết lập màu sắc thanh trạng thái trong suốt
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SettingsProvider()),
        ChangeNotifierProvider(create: (_) => BookmarkProvider()),
        ChangeNotifierProvider(create: (_) => ReadingHistoryProvider()),
        ChangeNotifierProvider(create: (_) => PracticeProvider()),
      ],
      child: const MocKinhApp(),
    ),
  );
}

class MocKinhApp extends StatelessWidget {
  const MocKinhApp({super.key});

  @override
  Widget build(BuildContext context) {
    const Color mocBackgroundLight = Color(0xFFFDFBF7);
    const Color mocTextLight = Color(0xFF2D2825);
    const Color mocPrimary = Color(0xFF8B5A2B);

    const Color mocBackgroundDark = Color(0xFF1A1A1A);
    const Color mocTextDark = Color(0xFFE0E0E0);
    const Color mocPrimaryDark = Color(0xFFD4A373);

    final settingsProvider = Provider.of<SettingsProvider>(context);

    return MaterialApp(
      title: 'Mộc Kinh',
      debugShowCheckedModeBanner: false,
      themeMode: settingsProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,

      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: mocPrimary,
        colorScheme: ColorScheme.fromSeed(
          seedColor: mocPrimary,
          brightness: Brightness.light,
          primary: mocPrimary,
          surface: mocBackgroundLight,
          onSurface: mocTextLight,
        ),
        scaffoldBackgroundColor: mocBackgroundLight,
        textTheme: GoogleFonts.loraTextTheme().apply(
          bodyColor: mocTextLight,
          displayColor: mocTextLight,
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          iconTheme: const IconThemeData(color: mocTextLight),
          titleTextStyle: GoogleFonts.lora(
            color: mocTextLight,
            fontSize: 22,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: mocPrimaryDark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: mocPrimaryDark,
          brightness: Brightness.dark,
          primary: mocPrimaryDark,
          surface: mocBackgroundDark,
          onSurface: mocTextDark,
        ),
        scaffoldBackgroundColor: mocBackgroundDark,
        textTheme: GoogleFonts.loraTextTheme().apply(
          bodyColor: mocTextDark,
          displayColor: mocTextDark,
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          iconTheme: const IconThemeData(color: mocTextDark),
          titleTextStyle: GoogleFonts.lora(
            color: mocTextDark,
            fontSize: 22,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      initialRoute: '/',
      routes: {
        '/': (context) => const MainScreen(),
        '/reader': (context) => const ReaderScreen(),
      },
    );
  }
}
