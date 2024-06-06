import 'package:flutter/material.dart';
import 'package:zkmf2024_app/constants.dart';
import 'package:zkmf2024_app/utils.dart';
import 'package:zkmf2024_app/widgets/to_home_action.dart';

class VerpflegungScreen extends StatelessWidget {
  const VerpflegungScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Verpflegung"),
          actions: homeAction(context),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              const ListTile(
                title: Text(
                  "Verpflegung Publikum",
                  style: TextStyle(fontWeight: FontWeight.bold, color: gruen),
                ),
              ),
              ExpansionTile(
                title: const Text("Festzelt Urdorf"),
                children: [
                  textBlock("""
**Freitag**, 21.06., 17.30 – 02.00 Uhr  
**Samstag**, 22.06., 09.00 – 04.00 Uhr  
**Sonntag**, 23.06., 09.00 – 20.00 Uhr  

* Getränke und Gipfeli von 09.00 – 12.00 Uhr
* Würste vom Grill und Pommes Frites, diverse Getränke von 11.00 Uhr bis Sperrstunde
* Barbetrieb: von 18.00 Uhr bis Sperrstunde (bzw. 20.00 Uhr am Sonntag)
                  """)
                ],
              ),
              ExpansionTile(
                title: const Text("Festzelt Schlieren"),
                children: [
                  textBlock("""
**Samstag**, 22.06., 09.00 – 16.00 Uhr  
**Sonntag**, 23.06., 09.00 – 16.00 Uhr  

* Getränke und Gipfeli ab Öffnung Festzelt bis 12.00 Uhr
* Würste vom Grill und Pommes Frites, diverse Getränke von 11.00 Uhr bis 16.00 Uhr
                  """)
                ],
              ),
              ExpansionTile(
                title: const Text("Food-Meile Urdorf"),
                children: [
                  textBlock("""
(Freitagabend, Samstag und Sonntag; individuelle Öffnungszeiten der Standbetreiber)  

* **Haldengut**: Bier, diverse Getränke
* **Fisch’s Frische Fische**: Frittiertes: Fisch, Shrimps, Calamares und Poulet, Country Fries
* **Heidi’s Raclette Stübli**: Raclette & Käseschnitten
* **Rudolf’s Knoblibrot**: Knoblibrot, Brezel & Pinsa
* **Vital Jus**: Patacones (frittierte Kochbananen)
* **Vorstadtbeiz Truck**: Hörnli & Burger
* **Confiserie Filisetti**: Gebrannte Mandeln & diverse Süssigkeiten
* **Gelati Leonardo**: Diverse Glacésorten
                  """)
                ],
              ),
              ExpansionTile(
                title: const Text("Food-Meile Schlieren"),
                children: [
                  textBlock("""
(Samstag und Sonntag; individuelle Öffnungszeiten der Standbetreiber)  

* **Haldengut**: Bier, diverse Getränke
* **MexicaSuiza**: Fajitas & Burritos
* **Heidi’s Raclette Stübli**: Raclette & Käseschnitten
* **Rudolf’s Knoblibrot**: Knoblibrot, Brezel & Pinsa, Soft Ice
* **Axarace**: Crèperie & diverse Snacks
* **Confiserie Filisetti**: Gebrannte Mandeln & diverse Süssigkeiten
* **Gelati Leonardo**: Diverse Glacésorten (im Festzelt)
                  """)
                ],
              ),
              const ListTile(
                title: Text(
                  "Verpflegung Musizierende (Catering)",
                  style: TextStyle(fontWeight: FontWeight.bold, color: gruen),
                ),
              ),
              ExpansionTile(
                title: const Text("Festzelt Urdorf"),
                children: [
                  textBlock("""
**Samstag** 22.06. und **Sonntag** 23.06., jeweils zwischen 11.00 und 15.00 Uhr
                  """)
                ],
              )
            ],
          ),
        ));
  }
}
