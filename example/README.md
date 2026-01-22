<img width="590" height="1278" alt="IMG_0481" src="https://github.com/user-attachments/assets/1bbe9c7d-c0ca-4933-b1b8-75cff4722ed3" /># ZoneLøb – Mobil sundhedsteknologi

Zoneløb er en løbeapp som er udviklet i Flutter og Dart. Her er fokuset på løbetræning i en konkret pulszone. Der benyttes mobile health i form af Movesense pulsmåler. Under løbet får brugeren feedback løbende og på den måde fortæller brugeren om de er i den rigtige zone. 

---

## Funktionalitet
- Forbindelse til Movesense pulssensor via Bluetooth Low Energy (BLE)
- Valg af ønsket pulszone før løb
- Realtidsvisning af puls, distance, tid og pulszone
- Feedback når brugeren bevæger sig ind og ud af den valgte zone
- Lokal lagring af træningsdata
- Eksport af pulsdata som JSON til efterfølgende analyse
- Historik over tidligere løbeture
<img width="590" height="1278" alt="IMG_0481" src="https://github.com/user-attachments/assets/44b45f8d-88b2-4fd1-a737-6594c612a555" />
<img width="590" height="1278" alt="IMG_0480" src="https://github.com/user-attachments/assets/9ce96ee9-57b0-4620-9caa-569064af28a3" />
<img width="590" height="1278" alt="IMG_0479" src="https://github.com/user-attachments/assets/7b4932a3-4d55-47e9-bb5f-823f6ea810a0" />

---
## Installation
1. Klon repository:
   git clone https://github.com/brugernavn/projekt.git
2. Kør:
   flutter pub get
3. Start appen:
   flutter run

   ## Brug
1. Indtaste alder
2. Forbind til sensor
1. Tryk "Start run" for at begynde løb
2. Appen giver feedback baseret på puls
3. Tryk "Stop run" for at se historik

## Arkitektur – MVVM

ZoneLøb er opbygget efter **MVVM (Model–View–ViewModel)**-arkitekturen:

### Model
Indeholder de rene dataklasser er repræsenteret. I ZoneLøb-appen består
model-laget af filerne RunHistory, RunSession og SensorData. 

### View
View er den del af appen, som brugeren interagerer med — altså selve bruger-
grænsefladen. Dette er de visuelle skærme, der navigeres imellem, og den UI-opbygning
som brugeren benytter. Her registreres brugerens input, som derefter sendes videre til
ViewModel-laget.

### ViewModel
ViewModel-laget fungerer som bindeled mellem view og model. Det er her, funktion-
aliteten ligger: ViewModel tager imod brugerens input fra view-laget, benytter data fra model-laget og sender derefter de korrekte og opdaterede data tilbage til view-laget

---
## Zoneberegning
- Estimerer makspuls ved at bruge formlen 220 − alder.
- Makspulsen bruges som udgangspunkt for at beregne pulszoner.
- Hver zone er et procentinterval af makspulsen (fx 50–60 %, 60–70 %, osv.).
- Minimums- og maksimumspuls for en zone findes ved at gange makspulsen med zonens procentgrænser.

---
## Begrænsninger
- Kun testet på iOS og macOS
- Android ikke understøttet
- Kræver Movesense sensor

## Database 
Appen anvender **Sembast** som lokal database til lagring af træningsdata.
Alle puls-målinger gemmes med tidsstempel og kan efterfølgende eksporteres som JSON.

## Implementering
- Flutter 3.38.7
- Dart 3.10.7
- Bluetooth Low Energy (BLE)
- Movesense-pulssensor
- Sembast (lokal database)
- Python (dataanalyse og visualisering)


