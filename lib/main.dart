import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const El3abApp());
}

class El3abApp extends StatelessWidget {
  const El3abApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int coins = 0;

  @override
  void initState() {
    super.initState();
    loadCoins();
  }

  Future<void> loadCoins() async {
    final p = await SharedPreferences.getInstance();
    setState(() {
      coins = p.getInt('coins') ?? 0;
    });
  }

  Future<void> addCoins(int c) async {
    final p = await SharedPreferences.getInstance();
    setState(() {
      coins += c;
    });
    await p.setInt('coins', coins);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('كسبت $c كوينز - رصيدك: $coins')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('العب واشحن - $coins')),
      body: GridView.count(
        crossAxisCount: 2,
        padding: const EdgeInsets.all(16),
        children: [
          gameCard('عجلة الحظ', () => addCoins(10)),
          gameCard('XO', () => addCoins(15)),
          gameCard('جمع الكوينز', () => addCoins(5)),
          gameCard('اسئلة', () => addCoins(20)),
          gameCard('الضغط السريع', () => addCoins(8)),
        ],
      ),
    );
  }

  Widget gameCard(String name, VoidCallback onTap) {
    return Card(
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.games, size: 40),
            const SizedBox(height: 10),
            Text(name, style: const TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}