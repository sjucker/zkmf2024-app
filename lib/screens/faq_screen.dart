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
        child: Column(
          children: [
            ExpansionTile(
              title: const Text("Bancomat"),
              children: [
                textBlock('''
**Urdorf**: ZKB mobiler Bancomat  
neben Schulhaus Feld 1, [Im Embri 49](https://maps.app.goo.gl/2EH2iJPR5iYxyzxe7)
'''),
                textBlock('''
**Schlieren**: ZKB  
[Zürcherstrasse 4](https://maps.app.goo.gl/CE1gCaKnmRr4zL4W8)
                ''')
              ],
            ),
            ExpansionTile(
              title: Text("Helferbüros"),
              children: [
                textBlock("**Urdorf**: Schulhaus Feld 1, [Im Embri 49](https://maps.app.goo.gl/2EH2iJPR5iYxyzxe7)"),
                textBlock(
                    "**Schlieren**: Familienzentrum, [Badenerstrasse 17](https://maps.app.goo.gl/D6akpGYAnvndUPzC8)"),
              ],
            ),
            ExpansionTile(
              title: Text("Info Points"),
              children: [
                textBlock('**Urdorf**: Vor dem Wettspiellokal Embrisaal, Im Embri 8'),
                textBlock("**Schlieren**: Piste 52, Nähe Bahnhof Zentrum"),
                textBlock("""
**Dienstleistungen**:
* Auskünfte aller Art für Besuchende, Teilnehmende, Medien, weitere
* Empfang teilnehmender Vereine und Funktionäre
* Abgabe von Festprogramm und Werbematerial
        """),
              ],
            ),
            ExpansionTile(
              title: Text("Instrumentenreparatur"),
              children: [
                ListTile(
                  title: MarkdownBody(
                    data: '**Urdorf**: Musikhaus Bucher',
                  ),
                  subtitle: MarkdownBody(data: "beim Foyer Schulhaus Embri, Im Embri 49"),
                ),
                ListTile(
                  title: MarkdownBody(
                    data: '**Schlieren**: Musikhaus Kubli',
                  ),
                  subtitle: MarkdownBody(data: "Kirchgasse 6"),
                )
              ],
            ),
            ExpansionTile(
              title: Text("Parkplätze"),
              children: [
                textBlock(
                  '**Die Anzahl öffentlicher Parkplätze in der Nähe der Festgelände Urdorf und Schlieren ist sehr beschränkt. Es wird deshalb dringend empfohlen, mit den öffentlichen Verkehrsmitteln anzureisen.**',
                ),
                ListTile(
                  title: MarkdownBody(
                    data: '''
**Verfügbare öffentliche Parkplätze Urdorf (Beschilderung, Verkehrsdienst)**:  
Industriegebiet Bergermoos, Autobahnausfahrt Urdorf Süd Die Parkplätze befinden sich an der Schützenstrasse, an der Bergermoosstrasse und an der Heinrich-Stutz-Strasse. Busverbindung zum Festplatz Urdorf ab Heinrich-Stutz-Strasse.''',
                  ),
                ),
                ListTile(
                  title: MarkdownBody(
                    data: '''
Parkplätze für Funktionäre (Kontrolle Name, Funktion und Kontrollschild):  
**Urdorf**:
* OK und Jury: Gemeindehaus Urdorf, Bahnhofstrasse und Schulstrasse (die Parkplätze sind signalisiert und es werden Parkbewilligungen abgegeben)
* OK und Jury: Schulanlage Weihermatt, Weihermattstrasse (nur mit Parkbewilligung)
* OK und Funktionäre: Parkplatz Zwischenbächen (die Parkplätze sind signalisiert und es werden Parkbewilligungen abgegeben)
* Cars/Busse Musikvereine: Luberzenareal, gegenüber den Gebäuden In der Luberzen 8–12 (Zufahrt via Im Grossherweg)
* Cars (Reserve-Parkplatz): Parkplatz Reppischtalstrasse
* Menschen mit Behinderung: Krummackerstrasse, unterster Parkplatz Schule  

**Schlieren**:
* Funktionäre, OK, Jury und Menschen mit Behinderung: Zentrum, Kiesplatz Piste 52
''',
                  ),
                )
              ],
            ),
            ExpansionTile(
              title: Text("Shuttle-Bus"),
              children: [],
            )
          ],
        ),
      ),
    );
  }

  Widget textBlock(String content) {
    return Column(
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
