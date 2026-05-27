import 'package:flutter/material.dart';

void main() {
  runApp(const GeoSvegliaApp());
}

class GeoSvegliaApp extends StatelessWidget {
  const GeoSvegliaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'GeoSveglia',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF121212),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF00E676), // Verde acido moderno
          secondary: Color(0xFF1E1E1E),
        ),
      ),
      home: const SplashPage(),
    );
  }
}

// --- SCHERMATA 1: SPLASH PAGE ---
class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Icona combinata: Pin + Sveglia
                Stack(
                  alignment: Alignment.center,
                  children: [
                    const Icon(Icons.location_on, size: 180, color: Color(0xFF00E676)),
                    Positioned(
                      top: 30,
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: const BoxDecoration(
                          color: Color(0xFF121212),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.access_time_filled, size: 60, color: Colors.white),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const Text(
                  'GeoSveglia',
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, letterSpacing: 2),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 50,
            left: 0,
            right: 0,
            child: Center(
              child: TextButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const HomePage()),
                  );
                },
                child: const Text(
                  'INIZIA →',
                  style: TextStyle(fontSize: 20, color: Color(0xFF00E676), fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// --- SCHERMATA 2: CORE CONFIGURATOR ---
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isAppActive = true;
  int selectedTrigger = 1; // 1: Entri, 2: Esci, 3: Dentro
  double radius = 500; // Raggio in metri
  
  final List<String> giorni = ['Lun', 'Mar', 'Mer', 'Gio', 'Ven', 'Sab', 'Dom'];
  final List<bool> giorniSelezionati = [true, true, true, true, true, false, false];
  final List<String> sveglieSalvate = [];

  void aggiungiSveglia() {
    setState(() {
      String triggerText = selectedTrigger == 1 ? "Entrata" : selectedTrigger == 2 ? "Uscita" : "Permanenza";
      sveglieSalvate.add("Area Raggio: ${radius.toInt()}m - Trigger: $triggerText");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('GeoSveglia', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          Switch(
            value: isAppActive,
            activeColor: const Color(0xFF00E676),
            onChanged: (value) {
              setState(() {
                isAppActive = value;
              });
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Blocco Mappa (Simulata)
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFF1E1E1E),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white10),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  const Icon(Icons.map, size: 80, color: Colors.white20),
                  // Pin e Raggio d'azione visivo
                  Container(
                    width: radius / 5, 
                    height: radius / 5,
                    maxHeight: 180,
                    maxWidth: 180,
                    decoration: BoxDecoration(
                      color: const Color(0xFF00E676).withOpacity(0.15),
                      shape: BoxShape.circle,
                      border: Border.all(color: const Color(0xFF00E676), width: 2),
                    ),
                  ),
                  const Icon(Icons.location_pin, size: 40, color: Colors.redAccent),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Text("Raggio: ", style: TextStyle(color: Colors.grey)),
                Text("${radius.toInt()} metri", style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF00E676))),
              ],
            ),
            Slider(
              value: radius,
              min: 100,
              max: 2000,
              activeColor: const Color(0xFF00E676),
              inactiveColor: Colors.white10,
              onChanged: (val) => setState(() => radius = val),
            ),
            const SizedBox(height: 15),

            // Blocco Giorni della settimana
            const Text('Giorni di attivazione', style: TextStyle(fontSize: 16, color: Colors.grey)),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(7, (index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      giorniSelezionati[index] = !giorniSelezionati[index];
                    });
                  },
                  child: Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: giorniSelezionati[index] ? const Color(0xFF00E676) : Colors.transparent,
                      shape: BoxShape.circle,
                      border: Border.all(color: giorniSelezionati[index] ? const Color(0xFF00E676) : Colors.white30),
                    ),
                    child: Center(
                      child: Text(
                        giorni[index],
                        style: TextStyle(
                          color: giorniSelezionati[index] ? Colors.black : Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
            const SizedBox(height: 25),

            // Blocco Opzioni Trigger
            const Text('Attiva la sveglia quando:', style: TextStyle(fontSize: 16, color: Colors.grey)),
            const SizedBox(height: 5),
            RadioListTile(
              title: const Text('Entri dentro l\'area'),
              value: 1,
              groupValue: selectedTrigger,
              activeColor: const Color(0xFF00E676),
              onChanged: (val) => setState(() => selectedTrigger = val as int),
            ),
            RadioListTile(
              title: const Text('Esci fuori dall\'area'),
              value: 2,
              groupValue: selectedTrigger,
              activeColor: const Color(0xFF00E676),
              onChanged: (val) => setState(() => selectedTrigger = val as int),
            ),
            RadioListTile(
              title: const Text('Ti trovi all\'interno dell\'area'),
              value: 3,
              groupValue: selectedTrigger,
              activeColor: const Color(0xFF00E676),
              onChanged: (val) => setState(() => selectedTrigger = val as int),
            ),
            const SizedBox(height: 15),

            // Tasto + e Lista Sveglie
            Center(
              child: IconButton(
                iconSize: 50,
                icon: const Icon(Icons.add_circle, color: Color(0xFF00E676)),
                onPressed: aggiungiSveglia,
              ),
            ),
            const SizedBox(height: 10),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: sveglieSalvate.length,
              itemBuilder: (context, index) {
                return Card(
                  color: const Color(0xFF1E1E1E),
                  margin: const EdgeInsets.symmetric(vertical: 5),
                  child: ListTile(
                    leading: const Icon(Icons.alarm, color: Color(0xFF00E676)),
                    title: Text(sveglieSalvate[index], style: const TextStyle(fontSize: 14)),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.redAccent),
                      onPressed: () {
                        setState(() {
                          sveglieSalvate.removeAt(index);
                        });
                      },
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 30),

            // Bottoni Annulla e Conferma
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {
                    setState(() {
                      sveglieSalvate.clear();
                    });
                  },
                  child: const Text('ANNULLA', style: TextStyle(color: Colors.grey, fontSize: 16)),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00E676),
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  ),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Configurazione Salvata con Successo!')),
                    );
                  },
                  child: const Text('CONFERMA', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}