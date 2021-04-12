import 'package:flutter/material.dart';

TextEditingController kdvController = new TextEditingController();
TextEditingController kdvOraniController = new TextEditingController();
int islemTuru = 0;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('KDV HESAPLAMA'),
        ),
        body: Center(
          child: HomeView(),
        ),
      ),
    );
  }
}

enum islem { kdvDahil, kdvHaric }

/// This is the stateful widget that the main application instantiates.
class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({Key? key}) : super(key: key);

  @override
  _MyStatefulWidgetState createState() => _MyStatefulWidgetState();
}

/// This is the private State class that goes with MyStatefulWidget.
class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  islem? _character = islem.kdvDahil;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ListTile(
          title: const Text('KDV Dahil Ücret Üzerinden İşlem Yap'),
          leading: Radio<islem>(
            value: islem.kdvDahil,
            groupValue: _character,
            onChanged: (islem? value) {
              setState(() {
                _character = value;
                islemTuru = 0;
              });
            },
          ),
        ),
        ListTile(
          title: const Text('KDV Hariç Ücret Üzerinden İşlem Yap'),
          leading: Radio<islem>(
            value: islem.kdvHaric,
            groupValue: _character,
            onChanged: (islem? value) {
              setState(() {
                _character = value;
                islemTuru = 1;
              });
            },
          ),
        ),
      ],
    );
  }
}

showAlertDialog(BuildContext context, String yazi) {
  // set up the button
  Widget okButton = TextButton(
    child: Text("Kapat"),
    onPressed: () {
      Navigator.of(context).pop();
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("Sonuç"),
    content: Text(yazi),
    actions: [
      okButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Scaffold(
            backgroundColor: Colors.transparent,
            body: Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                  Container(
                    child: MyStatefulWidget(),
                  ),
                  Container(
                    margin: EdgeInsets.all(20),
                    child: TextField(
                      keyboardType: TextInputType.number,
                      controller: kdvController,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Ücret',
                          hintText: "Ücreti giriniz..."),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(20),
                    child: TextField(
                      keyboardType: TextInputType.number,
                      controller: kdvOraniController,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'KDV',
                          hintText: "KDV tutarını yazınız."),
                    ),
                  ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Container(
                          child: ElevatedButton(
                            onPressed: () {
                              if ((kdvController.text.trim().isNotEmpty &&
                                  kdvOraniController.text.trim().isNotEmpty)) {
                                _hesaplama(islemTuru, context);
                              } else {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                        content: Text(
                                            "Lütfen boş yer bırakmayınız."));
                                  },
                                );
                              }
                            },
                            child: Text("Hesapla"),
                          ),
                        ),
                        Container(
                            child: ElevatedButton(
                                onPressed: () {
                                  kdvOraniController.clear();
                                  kdvController.clear();
                                },
                                child: Text("Temizle")))
                      ])
                ]))));
  }

  _hesaplama(int islem, BuildContext context) {
    double tutar = double.parse(kdvController.text) as double;
    double kdv = double.parse(kdvOraniController.text) as double;
    switch (islem) {
      case 0:
        double kdvTutari = (kdv / 100) + 1.00;
        double kdvHaricTutar = tutar / kdvTutari;
        double kdvTutar = -(kdvHaricTutar - tutar);

        print("KDV Hariç Tutar :" + kdvHaricTutar.toString());
        print("KDV Tutarı :" + kdvTutar.toString());

        showAlertDialog(
            context,
            "KDV Hariç Tutar :" +
                kdvHaricTutar.toStringAsFixed(2) +
                " TL \n" +
                "KDV Tutarı :" +
                kdvTutar.toStringAsFixed(2) +
                " TL\n" +
                "KDV Dahil Tutar :" +
                tutar.toString() +
                " TL");

        break;
      case 1:
        double kdvTutari = (tutar / 100) * kdv;
        double toplamTutar = tutar + kdvTutari;
        print("KDV Tutarı :" + kdvTutari.toString());
        print("KDV Dahil :" + toplamTutar.toString());

        showAlertDialog(
            context,
            "KDV Hariç Tutar :" +
                tutar.toString() +
                " TL\n" +
                "KDV Tutarı :" +
                kdvTutari.toStringAsFixed(2) +
                " TL\n" +
                "KDV Dahil :" +
                toplamTutar.toStringAsFixed(2));
        break;
      default:
        break;
    }
  }
}
