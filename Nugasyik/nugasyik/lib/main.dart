import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:nugasyik/next_page.dart';
import 'package:nugasyik/db_provider.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => DbProvider(),
      child: MaterialApp(
        title: 'Nugasyik',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const MyHomePage(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final Future<SharedPreferences> _preference = SharedPreferences.getInstance();
  bool _isLogin = false;

  void setIsLogin() async {
    final SharedPreferences prefs = await _preference;
    setState(() {
      _isLogin = !_isLogin;
    });
    prefs.setBool('is_login', _isLogin);
  }

  void getIsLogin() async {
    final SharedPreferences prefs = await _preference;
    setState(() {
      _isLogin = prefs.getBool('is_login') ?? _isLogin;
    });

    if (_isLogin) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => NextPage(),
        ),
      );
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getIsLogin();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.only(left: 20, right: 20),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                "assets/nugasyuk.png",
                width: 200,
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "Harap login terlebih dahulu",
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(
                height: 20,
              ),
              TextField(
                decoration: InputDecoration(
                    hintText: "Username",
                    filled: true,
                    border: OutlineInputBorder()),
              ),
              SizedBox(
                height: 10,
              ),
              TextField(
                obscureText: true,
                decoration: InputDecoration(
                    hintText: "Password",
                    filled: true,
                    border: OutlineInputBorder()),
              ),
              SizedBox(
                height: 10,
              ),
              Center(
                child: Container(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      setIsLogin();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => NextPage(),
                        ),
                      );
                    },
                    child: Text(
                      "LOGIN",
                      style: TextStyle(fontSize: 20),
                    ),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 75, 57, 239)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
