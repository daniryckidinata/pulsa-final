import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:pulsa/pulsa_model.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  PulsaModel itemSelected = PulsaModel(id: 0, nominal: 0, price: 0);

  Future<List<PulsaModel>> loadPulsaFromJson() async {
    final String jsonString = await rootBundle.loadString('assets/data.json');
    final jsonData = json.decode(jsonString);

    final result =
        (jsonData['data'] as List).map((e) => PulsaModel.fromJson(e)).toList();

    return result;
  }

  String formatRupiah(int amount) {
    final String amountStr = amount.toString();
    String result = '';
    int count = 0;

    for (int i = amountStr.length - 1; i >= 0; i--) {
      result = '${amountStr[i]}$result';
      count++;
      if (count == 3 && i != 0) {
        result = '.$result';
        count = 0;
      }
    }

    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Toko Pulsa"),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Mau beli pulsa berapa?",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Center(
                child: FutureBuilder<List<PulsaModel>>(
                  future: loadPulsaFromJson(),
                  builder: (
                    BuildContext context,
                    AsyncSnapshot<List<PulsaModel>> snapshot,
                  ) {
                    if (snapshot.hasData) {
                      final books = snapshot.data!;
                      return GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          // childAspectRatio: 2,
                          mainAxisExtent: 70,
                        ),
                        itemCount: books.length,
                        itemBuilder: (BuildContext context, int index) {
                          int id = index + 1;
                          final book = books[index];
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                itemSelected = book;
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: itemSelected.id == id
                                    ? Colors.green.withOpacity(0.1)
                                    : Colors.white,
                                border: Border.all(
                                  color: itemSelected.id == id
                                      ? Colors.green
                                      : Colors.grey,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(formatRupiah(book.nominal)),
                                  const SizedBox(height: 10),
                                  Text(
                                    "Rp${formatRupiah(book.price)}",
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    } else {
                      return const CircularProgressIndicator();
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: itemSelected.id != 0
          ? Container(
              padding: const EdgeInsets.all(20),
              width: MediaQuery.of(context).size.width,
              height: 100,
              decoration: const BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey,
                    offset: Offset(1, 4),
                    blurRadius: 3,
                    spreadRadius: 3,
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text("Total Bayar"),
                      const SizedBox(height: 5),
                      Text(
                        "Rp${formatRupiah(itemSelected.price)}",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          Future.delayed(const Duration(seconds: 3), () {
                            Navigator.pop(context);
                            setState(() {
                              itemSelected =
                                  PulsaModel(id: 0, nominal: 0, price: 0);
                            });
                          });
                          return LottieBuilder.network(
                              'https://assets4.lottiefiles.com/packages/lf20_vuliyhde.json');
                        },
                      );
                    },
                    style: const ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll(Colors.green),
                    ),
                    child: const Text("Lanjutkan"),
                  ),
                ],
              ),
            )
          : const SizedBox(),
    );
  }
}
