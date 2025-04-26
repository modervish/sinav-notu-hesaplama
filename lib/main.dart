import 'package:flutter/material.dart';

void main() {
  runApp(const NotHesapMakinesiApp());
}

class NotHesapMakinesiApp extends StatelessWidget {
  const NotHesapMakinesiApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Not Hesap Makinesi",
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(),
        ),
      ),
      home: const NotHesapMakinesiPage(),
    );
  }
}

class NotHesapMakinesiPage extends StatefulWidget {
  const NotHesapMakinesiPage({Key? key}) : super(key: key);

  @override
  _NotHesapMakinesiPageState createState() => _NotHesapMakinesiPageState();
}

class _NotHesapMakinesiPageState extends State<NotHesapMakinesiPage> {
  static const double _vizeYuzde = 0.4;
  static const double _finalYuzde = 0.6;

  final _formKey = GlobalKey<FormState>();
  final _vizeController = TextEditingController();
  final _finalController = TextEditingController();

  @override
  void dispose() {
    _vizeController.dispose();
    _finalController.dispose();
    super.dispose();
  }

  void _hesapla() {
    // Önce form validasyonu
    if (!_formKey.currentState!.validate()) return;

    final double vize = double.parse(_vizeController.text);
    final String finalText = _finalController.text;

    String sonuc;

    if (finalText.isEmpty) {
      // Final notu girilmemiş, gerekli final notunu hesapla
      final double gerekliFinal = (50 - vize * _vizeYuzde) / _finalYuzde;
      if (gerekliFinal > 100) {
        sonuc = "Geçmek için gerekli final notu 100'den büyük, dersten geçemezsiniz.";
      } else if (gerekliFinal <= 50) {
        sonuc = "Geçmek için final notunuzun en az 50 olması yeterli.";
      } else {
        sonuc = "Bu dersten geçmek için final notunuzun en az ${gerekliFinal.toStringAsFixed(2)} olması gerekiyor.";
      }
    } else {
      // Final notu girilmiş, normal hesaplama
      final double finalNot = double.parse(finalText);
      final double ort = vize * _vizeYuzde + finalNot * _finalYuzde;

      if (finalNot < 50) {
        sonuc = "Final notunuz 50'nin altında, dersten kaldınız.";
      } else if (ort >= 50) {
        sonuc = "Ortalama: ${ort.toStringAsFixed(2)}. Tebrikler, dersten geçtiniz!";
      } else {
        sonuc = "Ortalama: ${ort.toStringAsFixed(2)}. Maalesef, dersten kaldınız.";
      }
    }

    _showResult(sonuc);
  }

  void _showResult(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 4),
      ),
    );
  }

  String? _validateVize(String? value) {
    if (value == null || value.isEmpty) {
      return "Vize notu zorunludur.";
    }
    final double? parsed = double.tryParse(value);
    if (parsed == null) {
      return "Lütfen geçerli bir sayı giriniz.";
    }
    if (parsed < 0 || parsed > 100) {
      return "Not 0-100 arasında olmalıdır.";
    }
    return null;
  }

  String? _validateFinal(String? value) {
    if (value == null || value.isEmpty) {
      // boş geçilebilir, gerekli final notu hesaplanacak
      return null;
    }
    final double? parsed = double.tryParse(value);
    if (parsed == null) {
      return "Lütfen geçerli bir sayı giriniz.";
    }
    if (parsed < 0 || parsed > 100) {
      return "Not 0-100 arasında olmalıdır.";
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Not Hesap Makinesi")),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  controller: _vizeController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: "Vize Notu",
                    prefixIcon: Icon(Icons.edit),
                  ),
                  validator: _validateVize,
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _finalController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: "Final Notu (boş bırakırsanız gereken not hesaplanır)",
                    prefixIcon: Icon(Icons.edit),
                  ),
                  validator: _validateFinal,
                ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton.icon(
                      onPressed: _hesapla,
                      icon: const Icon(Icons.calculate),
                      label: const Text("Hesapla"),
                    ),
                    OutlinedButton.icon(
                      onPressed: () {
                        _formKey.currentState!.reset();
                        _vizeController.clear();
                        _finalController.clear();
                        ScaffoldMessenger.of(context).hideCurrentSnackBar();
                      },
                      icon: const Icon(Icons.clear),
                      label: const Text("Temizle"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
