# Stop Watch App

Una semplice e completa applicazione cronometro realizzata in Flutter, con supporto a:

- Start / Stop / Reset
- Pausa / Riprendi
- Aggiornamento del tempo tramite **Stream.periodic**
- Formattazione automatica del tempo (MM:SS oppure HH:MM:SS)
- Calcolo del tempo esteso (giorni, settimane, mesi, anni) per cronometri molto lunghi
- Supporto al tema chiaro e scuro
- Icone personalizzate tramite ```CustomIcons```

## Funzionalità principali

### **Avvio, Pausa, Stop, Reset**

- **Start** avvia il cronometro da 0.
- **Stop** blocca il tempo senza azzerarlo.
- **Reset** riporta tutto a 00:00.
- **Pause** mette in pausa il cronometro mentre è attivo.
- **Resume** riprende dalla pausa.

### **Sistema di timing**

Il cronometro si basa su:
```dart
Stream.periodic(Duration(milliseconds: 100))
```

Ogni 100 ms viene emesso un tick; ogni 10 tick (1 secondo) il timer aggiorna:
- secondi trascorsi (```_elapsedSeconds```)
- testo principale (```_timeText```)
- eventuale tempo extra (```_extraTimeText```)

### **Calcolo del tempo esteso**

Quando superi **24 ore**, viene mostrato anche:

- anni
- mesi
- settimane
- giorni
- ore/minuti/secondi

Esempio:
> 1 anno, 2 mesi, 1 settimana, 3 giorni, 4 ore, 12 minuti, 50 secondi

## Struttura del progetto
```csharp
fonts/
 ├── config.json        // File di configurazione delle icone personalizzate
 ├── CustomIcons.ttf    // File con la grafica delle icone personalizzate
lib/
 ├── main.dart          // Codice principale dell'app (UI + logica)
 ├── CustomIcons.dart   // Icone personalizzate (play, pause, stop, replay)
pubspec.yaml            // Configurazioni Flutter
pubspec.lock            // Lockfile generato da pub
```

## Avvio del progetto
Assicurati di avere Flutter installato (versione >= 3.0 consigliata).
#### **1. Clona o scarica il progetto**
```bash
git clone https://github.com/Fankyostro17/StopWatch.git
```
#### **2. Installa le dipendenze**
```bash
flutter pub get
```
#### **3. Avvia l'app**
```bash
flutter run
```

## Come funziona la logica del timer

#### **Stream dei tick**
```dart
_tickStream = Stream.periodic(Duration(milliseconds: 100), (i) => i);
```

#### **Filtro per ottenere 1 secondo**
```dart
.where((t) {
  if (_isRunning && !_isPaused && t != 0) {
    _tickCount++;
    return _tickCount % 10 == 0; // ogni 10 tick = 1 secondo
  }
  return false;
})
```

#### **Aggiornamento del tempo**
Viene calcolato automaticamente:
```dart
int hours = _elapsedSeconds ~/ 3600;
int min = (_elapsedSeconds % 3600) ~/ 60;
int sec = _elapsedSeconds % 60;
```

#### **Calcolo extra (giorni/mesi/anni)**
Funzione:
```dart
calculateExtraTime(int totalSeconds, int hoursData, int minData, int secData)
```

## Interfaccia
- Tempo principale in grande (fontSize: 120)
- Tempo esteso in piccolo e grigio
- Due FloatingActionButton:
    - Start/Stop/Reset
    - Pause/Resume

## Dipendenze principali
Nel ```pubspec.lock``` trovi pacchetti standard Flutter:
```async```, ```collection```, ```vector_math```, ecc.

Non sono richieste dipendenze esterne non standard.

## Requisiti
- Flutter SDK
- Dart SDK >= 2.18
- Ambiente Android/iOS/Windows/Linux/Web

## Licenza
MIT Licence