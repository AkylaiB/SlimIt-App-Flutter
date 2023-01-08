import 'dart:async';//Future ve Stream için
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';//link için
import 'package:url_launcher/url_launcher.dart';
import 'package:path_provider/path_provider.dart';//dosya işlemleri için
import 'dart:io';//dosya işlemleri
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:video_player/video_player.dart'; //<uses-permission android:name="android.permission.INTERNET"/>
import 'package:analog_clock/analog_clock.dart';
import 'package:pedometer/pedometer.dart';//<uses-permission android:name="android.permission.ACTIVITY_RECOGNITION" />

String cinsiyet = "";
double boy = 0.0;
double kilo = 0.0;
int yas = 0;
double aktiflik = 0.0;
bool bilgi_var = false;
int ac=0;
int ye=0;

Future<void> _read() async {
  String b = "";
  String k = "";
  String y = "";
  String a = "";
  try {
    final Directory directory1 = await getApplicationDocumentsDirectory();
    final File file1 = File('${directory1.path}/cinsiyet.txt');
    cinsiyet = await file1.readAsString();
    final Directory directory2 = await getApplicationDocumentsDirectory();
    final File file2 = File('${directory2.path}/boy.txt');
    b = await file2.readAsString();
    boy = double.parse(b);
    final Directory directory3 = await getApplicationDocumentsDirectory();
    final File file3 = File('${directory3.path}/kilo.txt');
    k = await file3.readAsString();
    kilo = double.parse(k);
    final Directory directory4 = await getApplicationDocumentsDirectory();
    final File file4 = File('${directory4.path}/yas.txt');
    y = await file4.readAsString();
    yas = int.parse(y);
    final Directory directory5 = await getApplicationDocumentsDirectory();
    final File file5 = File('${directory5.path}/aktiflik.txt');
    a = await file5.readAsString();
    aktiflik = double.parse(a);
  } catch (e) {
    print("Dosya okunamadı!");
  }
  if (cinsiyet != "" && b != "" && k != "" && y != "" && a != "")
    bilgi_var = true;
  else
    bilgi_var = false;
}

_write_c(String cins) async {
  cinsiyet = cins;
  final Directory directory = await getApplicationDocumentsDirectory();
  final File file = File('${directory.path}/cinsiyet.txt');
  await file.writeAsString(cins);
}

_write(String by, String kg, String ys) async {
  boy = double.parse(by);
  kilo = double.parse(kg);
  yas = int.parse(ys);
  final Directory directory = await getApplicationDocumentsDirectory();
  final File file = File('${directory.path}/boy.txt');
  await file.writeAsString(by);
  final Directory directory2 = await getApplicationDocumentsDirectory();
  final File file2 = File('${directory2.path}/kilo.txt');
  await file2.writeAsString(kg);
  final Directory directory3 = await getApplicationDocumentsDirectory();
  final File file3 = File('${directory3.path}/yas.txt');
  await file3.writeAsString(ys);
}

_write_a(String akt) async {
  aktiflik = double.parse(akt);
  final Directory directory = await getApplicationDocumentsDirectory();
  final File file = File('${directory.path}/aktiflik.txt');
  await file.writeAsString(akt);
}

void main() {
  _read();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp() {}

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, //köşedeki debug banneri
      theme: ThemeData(
          primarySwatch: Colors.indigo),
      home: bilgi_var ? Anasayfa() : Sayfa1(),
    );
  }
}

class Sayfa1 extends StatelessWidget {
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          title: Text(
        "Hoş geldiniz",
        textAlign: TextAlign.center,
      )),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("Cinsiyet",
                style: TextStyle(fontSize: 35, color: Colors.indigo)),
            ElevatedButton(
                style: ElevatedButton.styleFrom(fixedSize: const Size(125, 40)),
                child: Text("Kadın", style: TextStyle(fontSize: 20)),
                onPressed: () {
                  _write_c("Kadın");
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Sayfa2()),
                  );
                }),
            ElevatedButton(
                style: ElevatedButton.styleFrom(fixedSize: const Size(125, 40)),
                child: Text("Erkek", style: TextStyle(fontSize: 20)),
                onPressed: () {
                  _write_c("Erkek");
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Sayfa2()),
                  );
                }),
          ],
        ),
      ),
    );
  }
}

Future<void> _showAlertDialog1(context) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text("Bilgi eksikliği"),// <-- SEE HERE
        content: SingleChildScrollView(
          child: ListBody(
            children: [Text("Lütfen alanların hepsini doldurunuz!"),]
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Ok'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

class Sayfa2 extends StatelessWidget {
  Sayfa2();
  final _textController = TextEditingController();
  final _textController2 = TextEditingController();
  final _textController3 = TextEditingController();

  Widget build(BuildContext context) {
    print(cinsiyet);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          title: Text(
        "Hoş geldiniz",
        textAlign: TextAlign.center,
      )),
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
          TextField(
            controller: _textController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(
                labelStyle: TextStyle(fontSize: 20),
                labelText: "Boyunuz(metre):"),
          ),
          TextField(
            controller: _textController2,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(
                labelStyle: TextStyle(fontSize: 20), labelText: "Kilonuz(kg):"),
          ),
          TextField(
            controller: _textController3,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(
                labelStyle: TextStyle(fontSize: 20), labelText: "Yaşınız:"),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(fixedSize: const Size(125, 40)),
                child: Text("İleri", style: TextStyle(fontSize: 20)),
                onPressed: () {
                  if (_textController.text.isEmpty ||
                      _textController2.text.isEmpty ||
                      _textController3.text.isEmpty) {
                    _showAlertDialog1(context);
                  } else {
                    _write(_textController.text, _textController2.text,
                        _textController3.text);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Sayfa3()),
                    );
                  }
                }),
          ),
        ]),
      ),
    );
  }
}

class Sayfa3 extends StatelessWidget {
  Sayfa3();

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          title: Text(
        "Hoş geldiniz",
        textAlign: TextAlign.center,
      )),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("Hafta içi aktifliğiniz nedir?",
                style: TextStyle(fontSize: 25, color: Colors.indigo.shade700)),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigo.shade300,
                    fixedSize: const Size(250, 40)),
                child: Text("Minimum aktiflik", style: TextStyle(fontSize: 20)),
                onPressed: () {
                  _write_a("1.2");
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Anasayfa()),
                  );
                }),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigo.shade400,
                    fixedSize: const Size(250, 40)),
                child: Text("Haftada 1-3 gün spor",
                    style: TextStyle(fontSize: 20)),
                onPressed: () {
                  _write_a("1.375");
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Anasayfa()),
                  );
                }),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigo.shade500,
                    fixedSize: const Size(250, 40)),
                child: Text("Haftada 3-4 gün spor",
                    style: TextStyle(fontSize: 20)),
                onPressed: () {
                  _write_a("1.55");
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Anasayfa()),
                  );
                }),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigo.shade600,
                    fixedSize: const Size(250, 40)),
                child: Text("Haftada 5-6 gün spor",
                    style: TextStyle(fontSize: 20)),
                onPressed: () {
                  _write_a("1.7");
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Anasayfa()),
                  );
                }),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigo.shade700,
                    fixedSize: const Size(250, 40)),
                child: Text("Aşırı aktiflik", style: TextStyle(fontSize: 20)),
                onPressed: () {
                  _write_a("1.9");
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Anasayfa()),
                  );
                }),
          ],
        ),
      ),
    );
  }
}

class Anasayfa extends StatelessWidget {
  double vkt = 0;
  String verlecek_kg = "";
  String vkt_durum = "";
  Anasayfa();
  void vkt_hesapla() {
    vkt = kilo / (boy * boy);
    vkt = double.parse((vkt).toStringAsFixed(2));
    if (vkt < 16)
      vkt_durum = "Çok zayıf";
    else if (vkt < 18.5)
      vkt_durum = "Zayıf";
    else if (vkt < 25)
      vkt_durum = "Normal";
    else if (vkt < 30)
      vkt_durum = "Kilolu";
    else if (vkt < 35)
      vkt_durum = "1.derece obez";
    else if (vkt < 40)
      vkt_durum = "2.derece obez";
    else
      vkt_durum = "3.derece obez";
  }

  String sag_zayifla() {
    if (vkt < 18.5)
      verlecek_kg = "0.1-0.2";
    else if (vkt < 25)
      verlecek_kg = "0.2-0.5";
    else if (vkt < 30)
      verlecek_kg = "0.5-0.7";
    else
      verlecek_kg = "0.9-1.4";
    return verlecek_kg;
  }

  String kalori_normu() {
    double kalori;
    if (cinsiyet == "Kadın")
      kalori = 655.1 + (9.563 * kilo) + (1.85 * boy * 100) - (4.676 * yas);
    else //erkek
      kalori = 66.5 + (13.75 * kilo) + (5.003 * boy * 100) - (6.775 * yas);
    kalori = kalori * aktiflik;

    if (vkt < 35)
      kalori -= 500;
    else
      kalori -= 1000;
    kalori = double.parse((kalori).toStringAsFixed(2));

    return kalori.toString();
  }

  String su_normu() {
    double su;
    if (vkt < 25) //normal
      su = kilo * 30;
    else //kilolu
      su = kilo * 40;
    return su.toString();
  }

  Widget build(BuildContext context) {
    vkt_hesapla();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: Text("Home"),
      backgroundColor: Colors.blue,),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage("images/background1.jpg"),
              fit: BoxFit.cover,
          ),
        ),
        child:Column(children: [
          Container(
              height: MediaQuery.of(context).size.height / 2.7,
              child: SfRadialGauge(
                title: GaugeTitle(text: "Vücut Kitle İndeksi", textStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                backgroundColor: Colors.white.withOpacity(0.6),
                  axes: <RadialAxis>[
                    RadialAxis(startAngle: 180, endAngle: 0, minimum: 0, maximum: 60,axisLabelStyle: GaugeTextStyle( fontSize: 17,fontWeight: FontWeight.bold),canScaleToFit: true, ranges: <GaugeRange>[
                      GaugeRange(startValue: 0, endValue: 16, color: Colors.lightBlueAccent),
                      GaugeRange(startValue: 16, endValue: 18.5, color: Colors.blue),
                      GaugeRange(startValue: 18.5, endValue: 25, color: Colors.green),
                      GaugeRange(startValue: 25, endValue: 30, color: Colors.yellow),
                      GaugeRange(startValue: 30, endValue: 35, color: Colors.orange),
                      GaugeRange(startValue: 35, endValue: 40, color: Colors.deepOrange),
                      GaugeRange(startValue: 40, endValue: 60, color: Colors.red)
                    ],pointers: <GaugePointer>[
                      NeedlePointer(value: vkt),
                    ],annotations: <GaugeAnnotation>[
                      GaugeAnnotation(
                          widget: Container(
                              child: Text(vkt.toString()+" "+vkt_durum,
                                  style: TextStyle(
                                      fontSize: 15, fontWeight: FontWeight.bold))),
                          angle: 90, //textin bulunduğu konum açısı
                          positionFactor: 0.2)//textin ortaya yakınlık deerecesi
                    ])
                  ])
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: MediaQuery.of(context).size.width /3,
              height: MediaQuery.of(context).size.width /3,
              padding: new EdgeInsets.all(8.0),
              child: Card(
                child: Center( child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                      style: TextStyle(fontSize: 20,fontWeight: FontWeight.normal),
                      children: [
                        TextSpan(text: "Ağırlık\n"),
                        TextSpan(text: kilo.toString(), style: TextStyle(fontWeight: FontWeight.bold)),
                        TextSpan(text: " kg"),
                      ]
                  ),
                ),),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                color: Colors.orange,
                elevation: 20, //kartın altındaki gölgenin şekli
              ),),
            Container(
              width: MediaQuery.of(context).size.width /3,
              height: MediaQuery.of(context).size.width /3,
              padding: new EdgeInsets.all(8.0),
              child: Card(
                child: Center( child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                      style: TextStyle(fontSize: 20,fontWeight: FontWeight.normal),
                      children: [
                        TextSpan(text: "Boy\n"),
                        TextSpan(text: boy.toString(), style: TextStyle(fontWeight: FontWeight.bold)),
                        TextSpan(text: " metre"),
                      ]
                  ),
                ),),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                color: Colors.pinkAccent,
                elevation: 20,
              ),),
          ],
        ),
        Row(
          children: [
            Container(
              width: MediaQuery.of(context).size.width /3,
              height: MediaQuery.of(context).size.width /3,
              padding: new EdgeInsets.all(8.0),
              child: Card(
                child: Center( child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                      style: TextStyle(fontSize: 16,fontWeight: FontWeight.normal),
                      children: [
                        TextSpan(text: "Sağlıklı zayıflamak için haftada\n"),
                        TextSpan(text: sag_zayifla(), style: TextStyle(fontWeight: FontWeight.bold)),
                        TextSpan(text: " kg\nveriniz"),
                      ]
                  ),
                ),),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                color: Colors.deepPurpleAccent,
                elevation: 20,
              ),),

            Container(
              width: MediaQuery.of(context).size.width /3,
              height: MediaQuery.of(context).size.width /3,
              padding: new EdgeInsets.all(8.0),
              child: Card(
                child: Center( child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                      style: TextStyle(fontSize: 16,fontWeight: FontWeight.normal),
                      children: [
                        TextSpan(text: "Günlük kalori normunuz\n"),
                        TextSpan(text: kalori_normu(), style: TextStyle(fontWeight: FontWeight.bold)),
                        TextSpan(text: " kcal"),
                      ]
                  ),
                ),),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                color: Colors.green,
                elevation: 20,
              ),),

            Container(
              width: MediaQuery.of(context).size.width /3,
              height: MediaQuery.of(context).size.width /3,
              padding: new EdgeInsets.all(8.0),
              child: Card(
                child: Center( child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                      style: TextStyle(fontSize: 16,fontWeight: FontWeight.normal),
                      children: [
                        TextSpan(text: "Günlük su normunuz\n"),
                        TextSpan(text: su_normu(), style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold)),
                        TextSpan(text: " ml"),
                      ]
                  ),
                ),),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                color: Colors.lightBlue,
                elevation: 20,
              ),),
          ],
        ),
      ]),),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.fitness_center),
            label: 'Spor',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.emoji_food_beverage),
            label: 'Beslenme',
          ),
        ],
        onTap: (value) {
          if (value == 0) Navigator.of(context).push(MaterialPageRoute(builder: (context) => SporSayfa()));
          if (value == 1) Navigator.of(context).push(MaterialPageRoute(builder: (context) => BeslenmeSayfa()));
        },
      ),
    );
  }
}

class SporSayfa extends StatelessWidget {
  SporSayfa();

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: Text("Spor", style: TextStyle(fontSize: 25),)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row( children:[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: MediaQuery.of(context).size.width /2.2,
                height: MediaQuery.of(context).size.width /4,
                child: ElevatedButton(
                    child: Text("Egzersizler", style: TextStyle(fontSize: 25)),
                    onPressed: () {
                      if (cinsiyet == "Erkek") {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => EgzersizErkekSayfa()),
                        );
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => EgzersizKadinSayfa()),
                        );
                      }
                    }),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: MediaQuery.of(context).size.width /2.2,
                height: MediaQuery.of(context).size.width /4,
                child: ElevatedButton(
                  child: Text("Yoga", style: TextStyle(fontSize: 25)),
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => YogaSayfa()),
                  ),
                ),
              ),
            ),
            ]),
            Row( children:[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: MediaQuery.of(context).size.width /2.2,
                height: MediaQuery.of(context).size.width /4,
                child: ElevatedButton(
                  child: Text("Yürüme", style: TextStyle(fontSize: 25)),
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => YurumeSayfa()),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: MediaQuery.of(context).size.width /2.2,
                height: MediaQuery.of(context).size.width /4,
                child: ElevatedButton(
                  child: Text("Dans", style: TextStyle(fontSize: 25)),
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => DansSayfa()),
                  ),
                ),
              ),
            ),
            ]),
            Row( children:[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: MediaQuery.of(context).size.width /2.2,
                height: MediaQuery.of(context).size.width /4,
                child: ElevatedButton(
                  child: Text("İp atlama", style: TextStyle(fontSize: 25)),
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => IpAtlamaSayfa()),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: MediaQuery.of(context).size.width /2.2,
                height: MediaQuery.of(context).size.width /4,
                child: ElevatedButton(
                    child: Text("Aerobik", style: TextStyle(fontSize: 25)),
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AerobikSayfa()),
                    ),),
              ),
            ),
            ]),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: MediaQuery.of(context).size.width /2.2,
                height: MediaQuery.of(context).size.width /4,
                child: ElevatedButton(
                  child: Text("Plank", style: TextStyle(fontSize: 25)),
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => PlankSayfa()),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ListViewKadin extends StatelessWidget {
  ListViewKadin();
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(8),
      children: <Widget>[
        SizedBox(
          height: MediaQuery.of(context).size.height /5,
          child: Center(
            child: ListTile(
                leading: CircleAvatar(
                  backgroundImage: AssetImage("images/resHareket.jfif"),
                ),
                title: Text('Resimli zayıflama egzersizleri',style: TextStyle(fontSize: 18),),
              onTap: () => launch('https://www.diyadinnet.com/kadin-2871-resimli-zayiflama-egzersizleri'),
            ),
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height /5,
          child: Center(
            child: ListTile(
              leading: CircleAvatar(
                backgroundImage: AssetImage("images/kol.jfif"),
              ),
              title: Text('Kol eritme hareketleri',style: TextStyle(fontSize: 18),),
              onTap: () => launch('https://hareket.gen.tr/kol-eritme-hareketleri.html'),
            ),
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height /5,
          child: Center(
            child: ListTile(
              leading: CircleAvatar(
                backgroundImage: AssetImage("images/GobekKadin.jfif"),
              ),
              title: Text('Göbek eritme hareketleri',style: TextStyle(fontSize: 18),),
              onTap: () => launch('https://www.mynet.com/kadinlar-icin-gobek-eritme-hareketleri-1251618-mykadin'),
            ),
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height /5,
          child: Center(
            child: ListTile(
              leading: CircleAvatar(
                backgroundImage: AssetImage("images/evdeZayifKadin.jpg"),
              ),
              title: Text('Evde zayıflama hareketleri',style: TextStyle(fontSize: 18),),
              onTap: () => launch('https://www.obezitehaber.com/5-dakikada-evde-zayiflama-hareketleri/'),
            ),
          ),
        ),
      ],
    );
  }
}

class EgzersizKadinSayfa extends StatelessWidget {
  EgzersizKadinSayfa();

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          backgroundColor: Colors.green,
          title: Text("Kadınlar İçin Egzersizler")),
      body: Center(
        child:ListViewKadin()
      ),
    );
  }
}

class ListViewErkek extends StatelessWidget {
  ListViewErkek();
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(2),
      children: <Widget>[
        SizedBox(
          height: MediaQuery.of(context).size.height /5,
          child: Center(
            child: ListTile(
              leading: CircleAvatar(
                backgroundImage: AssetImage("images/e_7hareket.jpg"),
              ),
              title: Text('Erkeklerin her gün yapması gereken 7 egzersiz',style: TextStyle(fontSize: 18),),
              onTap: () => launch('https://www.iyihisset.com/sev/erkek/erkeklerin-her-gun-yapmasi-gereken-7-egzersiz'),
            ),
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height /5,
          child: Center(
            child: ListTile(
              leading: CircleAvatar(
                backgroundImage: AssetImage("images/gogus.jpg"),
              ),
              title: Text('Goğüs egzersizleri',style: TextStyle(fontSize: 18),),
              onTap: () => launch('https://www.rexona.com/tr/aktif-yasam/erkekler-icin-gogus-egzersizleri-nasil-olmali.html'),
            ),
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height /5,
          child: Center(
            child: ListTile(
              leading: CircleAvatar(
                backgroundImage: AssetImage("images/GobekErkek.jpg"),
              ),
              title: Text('Göbek eritme hareketleri',style: TextStyle(fontSize: 18),),
              onTap: () => launch('https://www.mynet.com/erkekler-icin-gobek-eritme-hareketleri-1251615-mykadin'),
            ),
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height/5,
          child: Center(
            child: ListTile(
              leading: CircleAvatar(
                backgroundImage: AssetImage("images/evdeZayifErkek.jpg"),
              ),
              title: Text('Evde zayıflama hareketleri',style: TextStyle(fontSize: 18),),
              onTap: () => launch('https://www.zayiflamadersleri.com/zayiflama-yontemleri/erkekler-icin-evde-zayiflama-egzersizleri.html'),
            ),
          ),
        ),
      ],
    );
  }
}

class EgzersizErkekSayfa extends StatelessWidget {
  EgzersizErkekSayfa();

  Widget build(BuildContext context) {
    void sec(){}
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          backgroundColor: Colors.green,
          title: Text("Erkekler için Egzersizler")),
      body: Center(
          child: ListViewErkek()
      ),
    );
  }
}

class YogaSayfa extends StatelessWidget {
  YogaSayfa();

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          backgroundColor: Colors.green,
          title: Text("Kilo verdiren yoga hareketleri")),
      body: SingleChildScrollView( child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("Savaşçı 1.Poz", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width/2.1,
                  height: MediaQuery.of(context).size.width/2.1,
                  child: Container(
                    margin: const EdgeInsets.all(10),
                    child: const Image(
                      fit: BoxFit.fill,
                      image: NetworkImage(
                          'https://th.bing.com/th/id/OIP.AAxJ4UfeclKUWIpr6E1nkwHaE7?pid=ImgDet&rs=1'),
                    ),
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width/2.1,
                  height: MediaQuery.of(context).size.width/2.1,
                  child: Container(
                    margin: const EdgeInsets.all(10),
                    child: const Image(
                      fit: BoxFit.fill,
                      image: NetworkImage(
                          'https://www.markstephensyoga.com/sites/default/files/YS11%20Ashta%20Chandra.jpg'),
                    ),
                  ),
                ),
              ],
            ),
            Text("Yana Streç Poz", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width/2.1,
                  height: MediaQuery.of(context).size.width/2.1,
                  child: Container(
                    margin: const EdgeInsets.all(10),
                    child: const Image(
                      fit: BoxFit.fill,
                      image: NetworkImage(
                          'https://yogaselection.com/wp-content/uploads/2017/08/parsvottanasana.jpg'),
                    ),
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width/2.1,
                  height: MediaQuery.of(context).size.width/2.1,
                  child: Container(
                    margin: const EdgeInsets.all(10),
                    child: const Image(
                      fit: BoxFit.fill,
                      image: NetworkImage(
                          'https://static.wixstatic.com/media/f497bf_217946c2000148288224c2948d9cfb7b~mv2_d_3000_2143_s_2.jpg/v1/fill/w_1000,h_714,al_c,q_90,usm_0.66_1.00_0.01/f497bf_217946c2000148288224c2948d9cfb7b~mv2_d_3000_2143_s_2.jpg'),
                    ),
                  ),
                ),
              ],
            ),
            Text("Yay Duruşu", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width/2.1,
                  height: MediaQuery.of(context).size.width/2.1,
                  child: Container(
                    margin: const EdgeInsets.all(10),
                    child: const Image(
                      fit: BoxFit.fill,
                      image: NetworkImage(
                          'https://static.wixstatic.com/media/a27d24_d7bb1e2c55ff49a08470504a7ebb8b23~mv2.jpg/v1/fill/w_1000,h_659,al_c,q_90,usm_0.66_1.00_0.01/a27d24_d7bb1e2c55ff49a08470504a7ebb8b23~mv2.jpg'),
                    ),
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width/2.1,
                  height: MediaQuery.of(context).size.width/2.1,
                  child: Container(
                    margin: const EdgeInsets.all(10),
                    child: const Image(
                      fit: BoxFit.fill,
                      image: NetworkImage(
                          'https://th.bing.com/th/id/OIP.Zb7euI_6tyxTCBx24hE2gQHaE8?pid=ImgDet&rs=1'),
                    ),
                  ),
                ),
              ],
            ),
            Text("Rüzgarı Serbest Bırakan Duruş", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width/2.1,
                  height: MediaQuery.of(context).size.width/2.1,
                  child: Container(
                    margin: const EdgeInsets.all(10),
                    child: const Image(
                      fit: BoxFit.fill,
                      image: NetworkImage(
                          'https://www.finessyoga.com/wp-content/uploads/2017/12/pawanmuktasana-01.jpg'),
                    ),
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width/2.1,
                  height: MediaQuery.of(context).size.width/2.1,
                  child: Container(
                    margin: const EdgeInsets.all(10),
                    child: const Image(
                      fit: BoxFit.fill,
                      image: NetworkImage(
                          'https://th.bing.com/th/id/R.0356a276089eac557fa1d06e69834230?rik=daQXKvKjpEy7xQ&pid=ImgRaw&r=0'),
                    ),
                  ),
                ),
              ],
            ),
            Text("Kobra Duruşu", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width/2.1,
                  height: MediaQuery.of(context).size.width/2.1,
                  child: Container(
                    margin: const EdgeInsets.all(10),
                    child: const Image(
                      fit: BoxFit.fill,
                      image: NetworkImage(
                          'https://www.damodara.com/wp-content/uploads/2019/11/guide-to-cobra-pose.jpg'),
                    ),
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width/2.1,
                  height: MediaQuery.of(context).size.width/2.1,
                  child: Container(
                    margin: const EdgeInsets.all(10),
                    child: const Image(
                      fit: BoxFit.fill,
                      image: NetworkImage(
                          'https://www.firstforwomen.com/wp-content/uploads/sites/2/2020/01/cobra-pose.jpg?w=1024'),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      ),
    );
  }
}

class YurumeSayfa extends StatefulWidget {
  @override
  _YurumeSayfaState createState() => _YurumeSayfaState();
}

class _YurumeSayfaState extends State<YurumeSayfa> {
  late Stream<StepCount> _stepCountStream;
  late Stream<PedestrianStatus> _pedestrianStatusStream;
  String _status = '?', _steps = '?';

  String durum(){
    String drm;
    if(_status=="walking")
      drm = "yuruyor";
    else
      drm = "duruyor";
    return drm;
  }
  @override
  void initState() {
    super.initState();
    initPlatformState();//cihazı dinler
  }

  void onStepCount(StepCount event) {
    print(event);
    setState(() {
      _steps = event.steps.toString();
    });
  }

  void onPedestrianStatusChanged(PedestrianStatus event) {
    print(event);
    setState(() {
      _status = event.status;
    });
  }

  void onPedestrianStatusError(error) {
    print('onPedestrianStatusError: $error');
    setState(() {
      _status = 'Yuruyucu durumu mevcut degildir';
    });
    print(_status);
  }

  void onStepCountError(error) {
    print('onStepCountError: $error');
    setState(() {
      _steps = 'Adım sayısı mevcut değildir';
    });
  }

  void initPlatformState() {
    _pedestrianStatusStream = Pedometer.pedestrianStatusStream;
    _pedestrianStatusStream.listen(onPedestrianStatusChanged).onError(onPedestrianStatusError);

    _stepCountStream = Pedometer.stepCountStream;
    _stepCountStream.listen(onStepCount).onError(onStepCountError);

    if (!mounted) return;//state bir daha değişmeyecekse
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Pedometre'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Adım sayısı:',
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              Text(
                _steps,
                style: TextStyle(fontSize: 30),
              ),
              Divider(
                height: 100,
                color: Colors.white,
              ),
              Text(
                'Yürüyücü durumu:',
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              Icon(
                _status == 'walking' ? Icons.directions_walk
                    : _status == 'stopping' ? Icons.man
                    : Icons.error,
                size: 100,
              ),
              Center(
                child: Text(
                  durum(),
                  style: _status == 'walking' || _status == 'stopping'
                      ? TextStyle(fontSize: 15)
                      : TextStyle(fontSize: 15, color: Colors.red),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class Video extends StatefulWidget {
  @override
  _VideoState createState() => _VideoState();
}

class _VideoState extends State<Video> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset(
        'videos/15dkantreman.mp4')
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Video Demo',
      home: Scaffold(
        body: Center(
            child: AspectRatio(
              aspectRatio: _controller.value.aspectRatio,//videonun kendi width/height oranını alması
              child: VideoPlayer(_controller),
            )
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            setState(() {
              _controller.value.isPlaying
                  ? _controller.pause()
                  : _controller.play();
            });
          },
          child: Icon(
            _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}
class DansSayfa extends StatelessWidget {
  DansSayfa();
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: Text("Danslar"), backgroundColor: Colors.red,),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
             SizedBox(
               width: MediaQuery.of(context).size.width,
                 height: 400,
                 child: Video()),
            Spacer(),
            Container(
              width: MediaQuery.of(context).size.width,
              height: 50,
              color: Colors.red,
              child: InkWell(
                onTap: () => launch('https://www.bing.com/videos/search?q=kilo+verdiren+danslar&FORM=HDRSC4'),
                child: Center(
                  child: Text(
                    'Daha fazla video için tıklayınız',
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                ),
              ),
            ),
          ],
      ),
      ),
    );
  }
}

class IpAtlamaSayfa extends StatelessWidget {
  IpAtlamaSayfa();

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: Text("İp atlama")),
      body: SingleChildScrollView(
        child:Center(
         child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              margin: const EdgeInsets.all(10),
              child: const Image(
                image: NetworkImage(
                    'https://blog.supplementler.com/wp-content/uploads/2020/09/shutterstock_359286821.jpg'),
              ),
            ),
            Text("İP ATLAMANIN FAYDALARI NELERDİR?", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Container(
              margin: const EdgeInsets.all(10),
              child:Text("İp atlamak sadece ip gerektirdiği ve başka hiçbir ekipman kullanılmadan yapılabildiği için oldukça basit ve ekonomik bir egzersiz olarak karşımıza çıkmaktadır. Kilo verme konusunda oldukça yardımcı olan ip atlama egzersizi ile her dakika başına 10 kalori yakabilirsiniz. "
                  "İp atlayarak zayıflamak için egzersiz süreleri kısa tutulmalıdır. Bu sayede vücudun gücü ve koordinasyon düzeyi de yükselecek, en üst seviyelere ulaşacaktır.Kısa süreli başlanan ip atlama egzersizlerinin süresi ve şiddeti her geçen gün arttırılmalıdır."
                  "İp atlama egzersizi, kilo vermeye yardımcı olmakla kalmamakta aynı zamanda kas kütlesinin de artışını sağlamaktadır. Çok kısa sürelerde uygulanmasına rağmen çok daha güçlü ve dinamik kaslara ulaşmaya yardımcı olur. Aynı zamanda vücut dengesinin de düzenlenmesine yardımcı olur."
                  "İp atlamak karın bölgesindeki kasların sıkılaşmasını sağlar. Bunun yanında baldır çevresindeki kasları da güçlendirir ve akciğer kapasitesinin artmasına yardımcı olur. İp atlama egzersizi bir tüm vücut antrenmanıdır, bu sayede vücut kondisyonunu geliştirir."
                  "İp atlama egzersizleri, kalp sağlığını düzenlemeye destek olur. Kalp ritmini arttıran bu egzersiz kalp atışının düzenlenmesini sağlar. Ancak herhangi bir kalp hastalığınız varsa ip atlama egzersizleri size çok yüksek tempolu gelebileceği için bu egzersizi denemeden önce kesinlikle bir kardiyolog ile iletişime geçmeli ve gereken testleri yaptırmalısınız."),
            ),
            Text("30 GÜNLÜK İP ATLAMA PROGRAMI", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Container(
                margin: const EdgeInsets.all(10),
                child: Text("İp atlama egzersizleri çok yüksek tempolu bir egzersiz çeşidi olduğu için vücuda birden yüklenmek hiç doğru bir hamle olmayacaktır. Düzgün bir ip atlama programı yapabilmek için düşük seviyelerde başlayıp şiddetin günden güne arttırılması gerekmektedir. 30 günlük bir ip atlama programında dikkat edilmesi gereken nokta egzersizlerin ilk 5 gününde günde 5 dakika ip atlamak 6. Günden itibaren her gün 1 dakika daha ekleyerek 30. Güne gelindiğinde günde 30 dakika ip atlıyor konumuna gelmek olacaktır. Bu düzende bir program hem zayıflamayı kolaylaştıracak hem de vücuda gereğinden fazla yük binmesini engellemiş olacaktır.")),
          ],
        ),
      ),
      ),
    );
  }
}

class AerobikSayfa extends StatelessWidget {
  AerobikSayfa();

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: Text("Aerobik"), backgroundColor: Colors.green,),
      body: SingleChildScrollView( child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("\nAerobik Egzersiz Nedir?",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20), ),
            Container(
                margin: const EdgeInsets.all(10),
                child: Text("Kısaca aerobik egzersiz, çok fazla yoğunluk gerektirmeyen ve uzun bir süre boyunca gerçekleştirilen egzersizler olarak tanımlanabilir. ")),
            Card(
              clipBehavior: Clip.antiAliasWithSaveLayer,
              child: Column(
                children: [
                  Image.network(
                    'https://i.ytimg.com/an_webp/XYH1mde9XsY/mqdefault_6s.webp?du=3000&sqp=CP6Zt50G&rs=AOn4CLDE72JyGZu43yph8f1rp-CpDtS-Pg',
                    fit: BoxFit.fill, height: 230, width: 250,
                  ),
                  InkWell(
                    onTap: () => launch("https://www.youtube.com/watch?v=DxecdQSlu3I"),
                    child: Center(
                      child: Text(
                        'Video için tıklayınız',
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              elevation: 5,
              margin: EdgeInsets.all(1),
            ),
            Text(""),
            Card(
              clipBehavior: Clip.antiAliasWithSaveLayer,//çok farklı bir arka plan rengi üzerine bindirilmiş bir görüntü için kenarları umuşatılmış bir card
              child: Column(
                children: [
                  Image.network(
                    'https://i.ytimg.com/an_webp/DxecdQSlu3I/mqdefault_6s.webp?du=3000&sqp=CLi3t50G&rs=AOn4CLB08HEvdWYNmdc0oueD_SSFnB2bNw',
                    fit: BoxFit.fill, height: 230, width: 250,
                  ),
                  InkWell(
                    onTap: () => launch("https://www.youtube.com/watch?v=XYH1mde9XsY"),
                    child: Center(
                      child: Text(
                        'Video için tıklayınız',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              elevation: 5,
              margin: EdgeInsets.all(1),
            ),
            Text("\nKilo Vermek İçin Etkili midir?",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20), ),
            Container(
                margin: const EdgeInsets.all(10),
                child: Text("Aerobik egzersiz, özellikle egzersiz sürecinin erken aşamalarında en çok tavsiye edilen ve kilo vermede etkili olan bir egzersiz çeşididir. Bunun nedeni, aerobik egzersizin vücutta biriken yağları ana tüketim kaynağı olarak kullanmasıdır. Bu yönüyle kilo vermek isteyen kişiler için idealdir.")),
          ],
        ),
      ),
      ),
    );
  }
}

class PlankSayfa extends StatelessWidget {
  PlankSayfa();

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: Text("Plank")),
      body:  SingleChildScrollView( child:Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              margin: const EdgeInsets.all(10),
              child: const Image(
                image: NetworkImage(
                    'https://img.grouponcdn.com/iam/mSRidKTtmGebi6UzkJuGa58jgvQ/mS-2048x1229/v1/c700x420.jpg'),
              ),
            ),
            Text("Plank Hareketi Zayıflatır Mı?",style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Text("Plank egzersizi, tek başına kilo vermenizi sağlamaz ancak düzenli beslenme programı ve kardiyo ile harika sonuçlar almanıza yardımcı olur. Plank hareketi kaç kalori sorusu, bu hareket sayesinde kilo vermeyi amaçlayanlar için sıklıkla soruluyor. 1 saatlik plank egzersizi uygulaması ile 400 kalori yakılabilir. Fakat bu hareketi 5 dakikadan fazla uygulamanız son derece zordur."),
            Image(image: AssetImage('images/PlankProgram.jfif')),
            Text("\nPlank Hareketinde Calisan Kaslar\n", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Image(image: AssetImage('images/Eplank.jpg')),
            Image(image: AssetImage('images/Kplank.jpg'))
          ],
        ),
      ),
      ),
    );
  }
}

class BeslenmeSayfa extends StatelessWidget {
  BeslenmeSayfa();

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: Text("Beslenme")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Card(
              clipBehavior: Clip.antiAliasWithSaveLayer,//linke basmayi gosteren animasyon
              child: Column(
                children: [
                  Image.network(
                    'https://sporvebeslenme.com/wp-content/uploads/2020/10/aralikli-oruc-diyeti-638x420.jpg',
                    fit: BoxFit.fill, height: 230, width: 250,
                  ),
                  InkWell(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => OrucSayfa()),
                    ),
                    child: Text(
                      'Aralikli Oruc',
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.black),
                    ),
                  ),
                ],
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              elevation: 5,
              margin: EdgeInsets.all(1),
            ),
            Card(
              clipBehavior: Clip.antiAliasWithSaveLayer,
              child: Column(
                children: [
                  Image.network(
                    'https://mawiss.ru/wp-content/uploads/2021/03/pp_diet.jpg',
                    fit: BoxFit.fill,height: 230, width: 250,
                  ),
                  InkWell(
                    onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => DiyetSayfa()),
                  ),
                    child: Text(
                      'Diyetler',
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.black),
                    ),
                  ),
                ],
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              elevation: 5,
              margin: EdgeInsets.all(1),
            ),
          ],
        ),
      ),
    );
  }
}


class DiyetSayfa extends StatelessWidget {
  DiyetSayfa();

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: Text("Kilo Verdirmede En Etkili 10 Diyet"),
      backgroundColor: Colors.black,),
      body: SingleChildScrollView( child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.width /4,
              child: Card(
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.0),
                      image: DecorationImage(
                          fit: BoxFit.cover,
                          image: AssetImage('images/alkaliDiyet.jpg', ),
                          colorFilter: ColorFilter.mode(Colors.white.withOpacity(0.4),BlendMode.modulate,),
                      )),
                  child: InkWell(
                  onTap: () => launch('https://hthayat.haberturk.com/saglik/diyet/haber/1013490-alkali-diyeti-nedir'),
                  child: Text(
                    'Alkali Diyet',
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                ),
                ),

                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                color: Colors.white12,
                elevation: 20,
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.width /4,
              child: Card(
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.0),
                      image: DecorationImage(
                          fit: BoxFit.cover,
                          image: AssetImage('images/isvecDiyet.jpg'),
                          colorFilter: ColorFilter.mode(Colors.white.withOpacity(0.4),BlendMode.modulate,),
                      )),
                  child: InkWell(
                  onTap: () => launch('https://hthayat.haberturk.com/saglik/diyet/haber/1031721-isvec-diyeti-nasil-yapilir'),
                  child: Text(
                    'İsveç Diyeti',
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                color: Colors.white12,
                elevation: 20,
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.width /4,
              child: Card(
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.0),
                      image: DecorationImage(
                          fit: BoxFit.cover,
                          image: AssetImage('images/gapsDiyet.jpg'),
                          colorFilter: ColorFilter.mode(Colors.white.withOpacity(0.4),BlendMode.modulate,),
                      )),
                  child: InkWell(
                  onTap: () => launch('https://hthayat.haberturk.com/saglik/diyet/haber/1046010-gaps-diyeti-nedir'),
                  child: Text(
                    'GAPS Diyeti',
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                color: Colors.white12,
                elevation: 20,
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.width /4,
              child: Card(
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.0),
                      image: DecorationImage(
                          fit: BoxFit.cover,
                          image: AssetImage('images/detoksDiyet.jpg'),
                          colorFilter: ColorFilter.mode(Colors.white.withOpacity(0.4),BlendMode.modulate,),
                      )),
                  child: InkWell(
                  onTap: () => launch('https://hthayat.haberturk.com/saglik/diyet/haber/1032752-detoks-diyeti-nasil-yapilir'),
                  child: Text(
                    'Detoks Diyeti',
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                color: Colors.white12,
                elevation: 20,
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.width /4,
              child: Card(
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.0),
                      image: DecorationImage(
                          fit: BoxFit.cover,
                          image: AssetImage('images/candidaDiyet.jpg'),
                          colorFilter: ColorFilter.mode(Colors.white.withOpacity(0.4),BlendMode.modulate,),
                      )),
                  child: InkWell(
                  onTap: () => launch('https://hthayat.haberturk.com/saglik/haber/1068388-candida-diyeti-nedir'),
                  child: Text(
                    'Candida Diyeti',
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                color: Colors.white12,
                elevation: 20,
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.width /4,
              child: Card(
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.0),
                      image: DecorationImage(
                          fit: BoxFit.cover,
                          image: AssetImage('images/3_3Diyet.jpg'),
                        colorFilter: ColorFilter.mode(Colors.white.withOpacity(0.4),BlendMode.modulate,),
                      )),
                  child: InkWell(
                  onTap: () => launch('https://hthayat.haberturk.com/saglik/diyet/haber/1014779-33-diyeti'),
                  child: Text(
                    ' 3+3 Diyeti',
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                color: Colors.white12,
                elevation: 20,
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.width /4,
              child: Card(
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.0),
                      image: DecorationImage(
                          fit: BoxFit.cover,
                          image: AssetImage('images/yumurtaDiyet.jpg'),
                          colorFilter: ColorFilter.mode(Colors.white.withOpacity(0.4),BlendMode.modulate,),
                      )),
                  child: InkWell(
                  onTap: () => launch('https://hthayat.haberturk.com/saglik/diyet/haber/1043083-yumurta-diyeti-ile-15-gunde-kilo-vermenin-yolu'),
                  child: Text(
                    'Yumurta Diyeti',
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                color: Colors.white12,
                elevation: 20,
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.width /4,
              child: Card(
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.0),
                      image: DecorationImage(
                          fit: BoxFit.cover,
                          image: AssetImage('images/lahanaDiyet.jpg'),
                          colorFilter: ColorFilter.mode(Colors.white.withOpacity(0.4),BlendMode.modulate,),
                      )),
                  child: InkWell(
                  onTap: () => launch('https://hthayat.haberturk.com/saglik/diyet/haber/1033241-lahana-diyeti-nasil-yapilir'),
                  child: Text(
                    'Lahana Diyeti',
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                color: Colors.white12,
                elevation: 20,
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.width /4,
              child: Card(
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.0),
                      image: DecorationImage(
                          fit: BoxFit.cover,
                          image: AssetImage('images/ketoDiyet.jpg'),
                        colorFilter: ColorFilter.mode(Colors.white.withOpacity(0.4),BlendMode.modulate,),
                      )),
                  child: InkWell(
                  onTap: () => launch('https://hthayat.haberturk.com/saglik/diyet/haber/1058559-ketojenik-diyet-nedir'),
                  child: Text(
                    'Ketojenik Diyet',
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                color: Colors.white12,
                elevation: 20,
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.width /4,
              child: Card(
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.0),
                      image: DecorationImage(
                          fit: BoxFit.cover,
                          image: AssetImage('images/15gunDiyet.jpg'),
                        colorFilter: ColorFilter.mode(Colors.white.withOpacity(0.4),BlendMode.modulate,),
                      )),
                  child: InkWell(
                  onTap: () => launch('https://hthayat.haberturk.com/saglik/diyet/haber/1040171-15-gunde-yaklasik-7-kilo-verdiren-diyet'),
                  child: Text(
                    '15 Günde 7 Kilo Verdiren Diyet',
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                color: Colors.white12,
                elevation: 20,
              ),
            ),
          ],
        ),
      ),
      ),
    );
  }
}

class Clock extends StatefulWidget {
  @override
  _ClockState createState() => _ClockState();

}

class _ClockState extends State<Clock> {
  var datetime = DateTime.now().toLocal();
  var baslangic="0";
  var bitis="0";
  setTime(){
    datetime = DateTime.now().toLocal();
    baslangic = datetime.hour.toString()+":"+datetime.minute.toString();
    if(ac==20 || ac==16){
      bitis = ((datetime.hour+ac)%24).toString()+":"+datetime.minute.toString();
    }else{
      bitis = (datetime.day+ac).toString()+"/"+datetime.month.toString()+"\n"+datetime.hour.toString()+":"+datetime.minute.toString();
    }
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
      body:Container(
          color: Colors.blue,
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 18.0),
                child: Text("Oruc Zamani\n", style: TextStyle( fontSize: 25, color: Colors.white),),
              ),
              Expanded(
                  child: AnalogClock(
                    decoration: BoxDecoration(
                        border: Border.all(width: 3.0, color: Colors.black),
                        color: Colors.white,
                        shape: BoxShape.circle), // decoration
                    width: 280.0,
                    isLive: true,
                    hourHandColor: Colors.black,
                    minuteHandColor: Colors.black,
                    showSecondHand: true,
                    numberColor: Colors.black,
                    showNumbers: true,
                    textScaleFactor: 1.5,//saatlerin büyüklüğü
                    showTicks: true,
                    showDigitalClock: true,
                    digitalClockColor: Colors.black,
                    datetime: datetime,
                  ),
              ),
              SizedBox(height: 30.0,),
              Expanded(child: Container(
                width: double.infinity,//parent kadar büyük olması için
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(topRight: Radius.circular(30.0),topLeft: Radius.circular(30.0)),
                ),
                child: Padding(
                  padding: EdgeInsets.only(top: 30.0, left: 20.0, right: 20.0),
                  child: Column(
                    children: <Widget>[
                      Expanded(child: Row(
                        children: <Widget>[
                          Expanded(child: Column(
                            children: <Widget>[
                              Text("Başlama Zamanı", style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, decoration: TextDecoration.underline),),
                              SizedBox(height: 10.0,),
                              Text(baslangic, style: TextStyle(fontSize: 35.0),),
                            ],
                          )),
                          Expanded(child: Column(
                            children: <Widget>[
                              Text("Bitiş Zamanı", style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, decoration: TextDecoration.underline),),
                              SizedBox(height: 10.0,),
                              Text(bitis, style: TextStyle(fontSize: 35.0),),
                            ],
                          ))
                        ],
                      )),
                      Padding(
                          padding: EdgeInsets.symmetric(vertical: 20.0),
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                setTime();
                              });
                            },
                            child: Padding(
                              padding: EdgeInsets.all(20.0),
                              child: Text("Orucu başlat",style: TextStyle(fontSize: 15.0), ),
                            ),
                            style: ButtonStyle(
                                shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                ),
                          )
                      ),
                      ),
                    ],
                  ),
                )
              ))
            ],
          )
      ),

    ));
  }
}

Future<void> _showAlertDialog(context, info, topic) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(topic),// <-- SEE HERE
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text(info),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Ok'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
class OrucSayfa extends StatelessWidget {
  OrucSayfa();

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          title: Text("Aralıklı Oruç"),
          actions: <Widget>[
            PopupMenuButton(
                child: Center(child:Text("Yöntemler", style: TextStyle(fontSize: 20),),),
                itemBuilder: (context){
                  return [
                    PopupMenuItem<int>(
                      value: 0,
                      child: Text("16:8 Yöntemi"),
                    ),

                    PopupMenuItem<int>(
                      value: 1,
                      child: Text("5:2 Yöntemi"),
                    ),

                    PopupMenuItem<int>(
                      value: 2,
                      child: Text("Ye-Dur-Ye Yöntemi"),
                    ),

                    PopupMenuItem<int>(
                      value: 3,
                      child: Text("1/1 Yontemi"),
                    ),

                    PopupMenuItem<int>(
                      value: 4,
                      child: Text("20:4 Yontemi"),
                    ),
                  ];
                },
                onSelected:(value){
                  if(value == 0){
                    ac = 16;
                    ye = 8;
                    String topic = "16:8 Yöntemi";
                    String info = "16 saat aç kalıp (uyku dahil), 8 saat yemek yeme şeklindedir. Örneğin; 11.00-19.00 saatleri arasında yemek yiyip, günün geri kalan kısmında herhangi bir besin tüketmiyorsunuz.";
                    _showAlertDialog(context,info,topic);
                  }else if(value == 1){
                    ac = 5;
                    ye = 2;
                    String topic = "5:2 Yöntemi";
                    String info = "Haftanın 5 günü normal, haftanın 2 günü çok kısıtlı kalori içerir (500-800 kcal/gün). Bu noktada kısıtlı yemek yenecek iki günün üst üste uygulanmaması sağlık açısından çok önemlidir. Kısıtlı yemek yenilen günlerde normal günlerde tüketilen besin miktarının 4’te 1’i tüketilir.";
                    _showAlertDialog(context,info,topic);
                  }else if(value == 2){
                    ac = 1;
                    ye = 6;
                    String topic = "Ye Dur Ye Yöntemi";
                    String info = "Haftada bir veya iki kez 24 saat oruç tutulan yöntemdir. Bir gün boyunca akşam yemeğinden sonra diğer akşam yemeğine kadar 24 saat geçirilir.";
                    _showAlertDialog(context,info,topic);
                  }else if(value == 3){
                    ac = 1;
                    ye = 1;
                    String topic = "1/1 Yöntemi";
                    String info = "Alternatif gün orucu veya diğer adıyla gün aşırı oruç yöntemiyle her diğer gün oruç tutarsınız. Birkaç farklı versiyonu vardır. Bazıları oruç günlerinde yaklaşık 500 kalori alır.";
                    _showAlertDialog(context,info,topic);
                  }else if(value == 4){
                    ac = 20;
                    ye = 4;
                    String topic = "20:4 Yontemı";
                    String info = "Gün içinde az miktarda çiğ meyve ve sebze yemeyi ve geceleri büyük bir öğün yemeyi içerir. Aslında, 20 saatlik oruç tutulur ve dört saatlik bir yemek penceresinde geceleri kocaman bir öğün yenir. Bu diyetin yiyecek seçenekleri, paleo diyetine çoğunlukla bütün, işlenmemiş yiyecekler tercih edildiğinden oldukça benzerdir.";
                    _showAlertDialog(context,info, topic);
                  }
                }
            ),
          ],
      ),
      body: Center(
        child: Clock()
      ),
    );
  }
}



