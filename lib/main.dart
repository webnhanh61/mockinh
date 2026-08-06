import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart'; // BẮT BUỘC IMPORT PROVIDER
import 'package:hive_flutter/hive_flutter.dart'; // BẮT BUỘC IMPORT HIVE

// Import Provider của mình
import 'providers/settings_provider.dart';

// Import các màn hình
import 'ui/screens/main_screen.dart';
import 'ui/screens/reader_screen.dart';

void main() async {
  // Đảm bảo Flutter bindings đã khởi tạo trước khi gọi Hive
  WidgetsFlutterBinding.ensureInitialized();

  // 1. Khởi tạo Hive
  await Hive.initFlutter();

  // Thiết lập màu sắc thanh trạng thái
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );

  // 2. Bọc TOÀN BỘ ứng dụng bằng MultiProvider NGAY TẠI ĐÂY
  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => SettingsProvider())],
      child: const MocKinhApp(),
    ),
  );
}

class MocKinhApp extends StatelessWidget {
  const MocKinhApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Định nghĩa bảng màu Mộc (Earth Tones)
    const Color mocBackgroundLight = Color(0xFFFDFBF7);
    const Color mocTextLight = Color(0xFF2D2825);
    const Color mocPrimary = Color(0xFF8B5A2B);

    const Color mocBackgroundDark = Color(0xFF1A1A1A);
    const Color mocTextDark = Color(0xFFE0E0E0);
    const Color mocPrimaryDark = Color(0xFFD4A373);

    // 3. Lắng nghe SettingsProvider để lấy trạng thái Dark Mode
    // Bây giờ việc gọi Provider.of chắc chắn thành công vì nó được bọc bởi MultiProvider ở trên
    final settingsProvider = Provider.of<SettingsProvider>(context);

    return MaterialApp(
      title: 'Mộc Kinh',
      debugShowCheckedModeBanner: false,

      // Chọn ThemeMode dựa vào trạng thái trong Provider
      themeMode: settingsProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,

      // --- LIGHT THEME ---
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

      // --- DARK THEME ---
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

      // Định tuyến
      initialRoute: '/',
      routes: {
        '/': (context) => const MainScreen(),
        '/reader': (context) => const ReaderScreen(),
      },
    );
  }
}
