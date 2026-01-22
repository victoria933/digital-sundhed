# ZoneLøb – Mobil sundhedsteknologi

Zoneløb er en løbeapp som er udviklet i Flutter og Dart. Her er fokuset på løbe træning i en konkret pulszone. Der benyttes mobile health i form af Movesense pulsmåler. Under løbet får brugere feedback løbende og på den måde fortæller brugeren om de er i den rigtige zone. 

---

## Funktionalitet
- Forbindelse til Movesense pulssensor via Bluetooth Low Energy (BLE)
- Realtidsvisning af puls og pulszoner
- Valg af ønsket pulszone før løb
- Feedback når brugeren bevæger sig ind og ud af den valgte zone
- Lokal lagring af træningsdata
- Eksport af pulsdata som JSON til efterfølgende analyse
- Historik over tidligere løbeture

---

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

## Datapersistens
Appen anvender **Sembast** som lokal database til lagring af træningsdata.
Alle puls-målinger gemmes med tidsstempel og kan efterfølgende eksporteres som JSON.

