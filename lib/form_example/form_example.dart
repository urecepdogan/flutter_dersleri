import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FormExampleScreen extends StatefulWidget {
  const FormExampleScreen({super.key});

  @override
  State<FormExampleScreen> createState() => _FormExampleScreenState();
}

class _FormExampleScreenState extends State<FormExampleScreen> {
  TextEditingController adController = TextEditingController();
  TextEditingController soyadController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController tcController = TextEditingController();
  TextEditingController telefonController = TextEditingController();
  int cinsiyetRadio = 1;
  final formKey = GlobalKey<FormState>();
  String dropdownValue = "";
  List<String> sehirler = ["Gaziantep", "Kahramanmaraş", "Hatay", "Şanlıurfa", "Adıyaman"];
  final maskFormatter = MaskTextInputFormatter(mask: '0(###)-###-##-##', filter: {"#": RegExp(r'[0-9]')}, type: MaskAutoCompletionType.lazy);

  late SharedPreferences prefs;
  @override
  void initState() {
    initialPreferences();

    super.initState();
  }

  initialPreferences() async {
    prefs = await SharedPreferences.getInstance();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text("Register", style: TextStyle(fontSize: 25)),
                  TextFormField(
                    decoration: const InputDecoration(hintText: "Ad"),
                    controller: adController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Zorunlu alan";
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    decoration: const InputDecoration(hintText: "Soyad"),
                    controller: soyadController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Zorunlu alan";
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    decoration: const InputDecoration(hintText: "Email"),
                    controller: emailController,
                    validator: (value) {
                      final bool emailValid =
                          RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(emailController.text);
                      if (value!.isEmpty) {
                        {
                          return " Zorunlu Alan";
                        }
                      }
                      if (emailValid == false) {
                        return "E-Mail doğru biçimde yazılmadı";
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    decoration: const InputDecoration(hintText: "TC"),
                    controller: tcController,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Zorunlu Alan";
                      }
                      if (value.length < 11) {
                        return "T.C. Kimlik No Eksik Girildi";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  const Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "Cinsiyet",
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  RadioListTile(
                      title: const Text("Bay"),
                      value: 1,
                      groupValue: cinsiyetRadio,
                      onChanged: (int? veri) {
                        setState(() {
                          cinsiyetRadio = veri ?? 0;
                        });
                      }),
                  RadioListTile(
                      title: const Text("Bayan"),
                      value: 2,
                      groupValue: cinsiyetRadio,
                      onChanged: (int? veri) {
                        setState(
                          () {
                            cinsiyetRadio = veri ?? 0;
                          },
                        );
                      }),
                  const Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "Şehir",
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  DropdownMenu<String>(
                    initialSelection: sehirler.first,
                    onSelected: (String? value) {
                      setState(() {
                        dropdownValue = value!;
                      });
                    },
                    dropdownMenuEntries: sehirler.map<DropdownMenuEntry<String>>((String value) {
                      return DropdownMenuEntry<String>(value: value, label: value);
                    }).toList(),
                  ),
                  TextFormField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Zorunlu Alan";
                      }
                      if (value.length < 16) {
                        return "Telefon No Eksik Girildi";
                      }
                      return null;
                    },
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(hintText: "Telefon"),
                    controller: telefonController,
                    inputFormatters: [maskFormatter],
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        if (formKey.currentState?.validate() ?? false) {
                          sendData();
                          print(prefs.getString('user'));
                        }
                      },
                      child: const Text("Kayıt Ol"),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void sendData() async {
    await prefs.setString("user",
        "{'name' : '${adController.text}', 'soyad' : '${soyadController.text}', 'email' : '${emailController.text}', 'tc' : '${tcController.text}', 'cinsiyet' : '$cinsiyetRadio' , 'sehir':'$dropdownValue' }");
  }
}
