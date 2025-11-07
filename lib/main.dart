// lib/main.dart

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        // Tambahkan ProductProvider di sini nanti
      ],
      child: const MyApp(),
    ),
  );
}