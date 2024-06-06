import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zkmf2024_app/widgets/to_home_action.dart';

class FaqScreen extends StatelessWidget {
  const FaqScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Gut zu wissen"),
        actions: homeAction(context),
      ),
      body: SingleChildScrollView(
          child: Column(children: [
        ExpansionTile(
          title: const Text("Bancomat"),
          children: [
            textBlock("""
**Urdorf**: ZKB mobiler Bancomat  
neben Schulhaus Feld 1, [Im Embri 49](https://maps.app.goo.gl/2EH2iJPR5iYxyzxe7)

**Schlieren**: ZKB, [Zürcherstrasse 4](https://maps.app.goo.gl/CE1gCaKnmRr4zL4W8)
                """)
          ],
        ),
        ExpansionTile(
          title: const Text("Helferbüros"),
          children: [
            textBlock("""
**Urdorf**: Schulhaus Feld 1, [Im Embri 49](https://maps.app.goo.gl/Jnr1LVooRcgsSg1M8)

**Schlieren**: Familienzentrum, [Badenerstrasse 17](https://maps.app.goo.gl/D6akpGYAnvndUPzC8)"""),
          ],
        ),
        ExpansionTile(
          title: const Text("Info Points"),
          children: [
            textBlock("""
**Urdorf**: Vor dem Wettspiellokal Embrisaal, Im Embri 8

**Schlieren**: Piste 52, Nähe Bahnhof Zentrum

**Dienstleistungen**:
* Auskünfte aller Art für Besuchende, Teilnehmende, Medien, weitere
* Empfang teilnehmender Vereine und Funktionäre
* Abgabe von Festprogramm und Werbematerial
        """),
          ],
        ),
        ExpansionTile(
          title: const Text("Instrumentenreparatur"),
          children: [
            textBlock("""
**Urdorf**: Musikhaus Bucher  
beim Foyer Schulhaus Embri, [Im Embri 49](https://maps.app.goo.gl/2EH2iJPR5iYxyzxe7)

**Schlieren**: Musikhaus Kubli, [Kirchgasse 6](https://maps.app.goo.gl/811fMmafLY3Gx6fp6)
                """),
          ],
        ),
        ExpansionTile(
          title: const Text("Parkplätze"),
          children: [
            textBlock("""
**Die Anzahl öffentlicher Parkplätze in der Nähe der Festgelände Urdorf und Schlieren ist sehr beschränkt. Es wird deshalb dringend empfohlen, mit den öffentlichen Verkehrsmitteln anzureisen.**

**Verfügbare öffentliche Parkplätze Urdorf (Beschilderung, Verkehrsdienst)**:  
Industriegebiet Bergermoos, Autobahnausfahrt Urdorf Süd Die Parkplätze befinden sich an der Schützenstrasse, an der Bergermoosstrasse und an der Heinrich-Stutz-Strasse. Busverbindung zum Festplatz Urdorf ab Heinrich-Stutz-Strasse.

**Parkplätze für Funktionäre (Kontrolle Name, Funktion und Kontrollschild)**:  

**Urdorf**:
* OK und Jury: Gemeindehaus Urdorf, Bahnhofstrasse und Schulstrasse (die Parkplätze sind signalisiert und es werden Parkbewilligungen abgegeben)
* OK und Jury: Schulanlage Weihermatt, Weihermattstrasse (nur mit Parkbewilligung)
* OK und Funktionäre: Parkplatz Zwischenbächen (die Parkplätze sind signalisiert und es werden Parkbewilligungen abgegeben)
* Cars/Busse Musikvereine: Luberzenareal, gegenüber den Gebäuden In der Luberzen 8–12 (Zufahrt via Im Grossherweg)
* Cars (Reserve-Parkplatz): Parkplatz Reppischtalstrasse
* Menschen mit Behinderung: Krummackerstrasse, unterster Parkplatz Schule  

**Schlieren**:
* Funktionäre, OK, Jury und Menschen mit Behinderung: Zentrum, Kiesplatz Piste 52
"""),
          ],
        ),
        ExpansionTile(
          title: const Text("Shuttle-Bus"),
          children: [
            textBlock("""
**Tickets**  
Besuchende ohne Festkarte müssen für die Fahrt im Shuttle-Bus ein Ticket lösen. Für Besuchende mit einer Festkarte «Teilnehmende» oder «Begleitperson» ist ein ZVV-Ticket «alle Zonen» (2. Klasse) vom 21.06.2024-23.06.2024 eingeschlossen. Die Festkarte mit dem Icon des ZVV auf der Rückseite gilt auch als Ticket für die Busfahrten mit dem Shuttle und muss auf Verlangen vorgewiesen werden.  

**Shuttle-Verbindung**  
**Urdorf -> Schlieren -> Urdorf**  
Die Verbindung zwischen Urdorf Heinrich-Stutz-Strasse (Parkplätze Bergermoos) und Schlieren wird zu folgenden Zeiten mit einer **Fahrplanverdichtung** gewährleistet: Samstag, 22. Juni 2024, und Sonntag, 23. Juni 2024, von 07.30 Uhr bis 18.00 Uhr, zwischen Schlieren, Brunngasse und Urdorf, HeinrichStutz-Strasse.  
**Route**: Schlieren Brunngasse – Nassacker – Rainweg – Neumattstrasse (Embri) – Urdorf Spitzacker – Heinrich-Stutz-Strasse und zurück  

Ab 18.00 Uhr sind die Parkplätze Bergermoos vom Festgelände Urdorf Spitzacker aus mit der ordentlichen Buslinie 314 zu erreichen.  
**Route**: Urdorf Spitzacker – Oberurdorf – Urdorf Heinrich-Stutz-Strasse und zurück  

**Nacht-Erschliessung Parkplätze Heinrich-Stutz-Strasse (Bergermoos)**:  
Spitzacker -> Heinrich-Stutz-Strasse -> Spitzacker

**Sonntag, 23. Juni 2O24**: Ein Pendelbus verkehrt von Samstag, 23.57 Uhr, bis Sonntag, 03.42 Uhr, ab Urdorf Spitzacker bis Urdorf Heinrich-Stutz-Strasse.

Sämtliche Fahrten sind im [Online-Fahrplan des ZVV](https://www.zvv.ch) abgebildet.
                """)
          ],
        ),
        ExpansionTile(
          title: const Text("Sicherheit / Notfall"),
          children: [
            textBlock("""
**Notrufnummern**:  
* Feuerwehr: [118](tel:118)
* Polizei: [117](tel:117)
* Sanität: [144](tel:144)
* Rega: [1414](tel:1414)
* TOX-Zentrum (Vergiftungen): [145](tel:145)

**Sicherheitsposten**:
* Urdorf: Schulhaus Feld 1  
Lehrerzimmer, [Im Embri 49](https://maps.app.goo.gl/zMdBL8j2252KatFBA)
* Schlieren: Alter Jugendraum, Kirchplatz

**Sanitätsposten (Samariterverein Altstetten-Albisrieden)**:
* Urdorf: Kerzenziehraum unterhalb Turnhalle Bahnhofstrasse (beim Festzelt), Im Moos 37
* Schlieren: Alter Jugendraum, Kirchplatz

**Apotheken**:
* Urdorf:
  * Birmensdorferstrasse 79, Tel.: [044 735 10 30](tel:0447351030), Mo-Fr 08.00-19.00, Sa 08.00-18.00
* Schlieren:
  * Ringstrasse 3, Tel.: [044 741 59 89](tel:0447415989), Mo-Fr 08.00-19.00 Uhr, Sa 08.30-17.00 Uhr
  * Uitikonerstrasse 9, Tel.: [044 730 59 89](tel:0447305989), Mo-Fr 08.00-19.00 Uhr, Sa 08.30-17.00 Uhr
  * Goldschlägiplatz 4, Tel.: [043 543 80 20](tel:0435438020), Mo-Sa: 08:30–19:00 Uhr

**Sammelplätze**:
* Urdorf: Mehrzweckhalle Zentrum Spitzacker  
[Birmensdorferstrasse 77](https://maps.app.goo.gl/b3XpwPC4LB1JV8h27)
* Schlieren: Kirchplatz

**Weitere**:
* OK-Büro: Schulsekretariat Schulhaus Embri, [Im Embri 49](https://maps.app.goo.gl/2EH2iJPR5iYxyzxe7), Urdorf
* Treffpunkt verlorene Kinder: OK-Büro, Schulsekretariat Embri, [Im Embri 49](https://maps.app.goo.gl/2EH2iJPR5iYxyzxe7), Urdorf
* Fundbüro: Sicherheitsposten Urdorf, Schulhaus Feld 1, Lehrerzimmer, [Im Embri 49](https://maps.app.goo.gl/2EH2iJPR5iYxyzxe7), Urdorf
        """),
          ],
        ),
        ExpansionTile(title: const Text("Toiletten"), children: [
          textBlock("""
* Urdorf: Schulhaus Feld 2 (Toilettenwagen), Marschmusikstrecke (Toitoi)  
Menschen mit Behinderung: Embrisaal, [Im Embri 8](https://maps.app.goo.gl/w9wocZyjiPD6J4LG9)
* Schlieren: Festzelt Schlieren (Toilettenwagen)
Menschen mit Behinderung: Familienzentrum, [Badenerstrasse 17a](https://maps.app.goo.gl/6oD7RG71Bz26t6wY7)
* Weitere Toiletten in den Wettspiellokalen, Einspiellokalen und Instrumentendepots  
    """)
        ]),
      ])),
    );
  }

  Widget textBlock(String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0),
          child: MarkdownBody(
            data: content,
            onTapLink: (text, href, title) {
              if (href != null) {
                launchUrl(Uri.parse(href));
              }
            },
          ),
        ),
      ],
    );
  }
}
