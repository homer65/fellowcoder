import 'package:flutter/material.dart';

class Nutzungsbedingungen extends StatefulWidget {
  static const String route = '/nutzungsbedingungen';
  @override
  _NutzungsbedingungenState createState() => _NutzungsbedingungenState();
}

class _NutzungsbedingungenState extends State<Nutzungsbedingungen> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  height: 40,
                ),
                Text(
                  "Nutzungsbedingungen",
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "Mit dem Zugriff auf „Fellowcoder“ („https://fellowcoder.org“) wird zwischen dir und dem Betreiber ein Vertrag mit folgenden Regelungen geschlossen:",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "1. Nutzungsvertrag",
                  style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
                ),
                Text(
                  """a. Mit dem Zugriff auf „Fellowcoder“ (im Folgenden „das Board“) schließt du einen Nutzungsvertrag mit dem Betreiber des Boards ab (im Folgenden „Betreiber“) und erklärst dich mit den nachfolgenden Regelungen einverstanden.
b. Wenn du mit diesen Regelungen nicht einverstanden bist, so darfst du das Board nicht weiter nutzen. Für die Nutzung des Boards gelten jeweils die an dieser Stelle veröffentlichten Regelungen.
c. Der Nutzungsvertrag wird auf unbestimmte Zeit geschlossen und kann von beiden Seiten ohne Einhaltung einer Frist jederzeit gekündigt werden.""",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "2. Gewährleistung",
                  style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
                ),
                Text(
                  """a. Der Betreiber haftet mit Ausnahme der Verletzung von Leben, Körper und Gesundheit und der Verletzung wesentlicher Vertragspflichten (Kardinalpflichten) nur für Schäden, die auf ein vorsätzliches oder grob fahrlässiges Verhalten zurückzuführen sind. Dies gilt auch für mittelbare Folgeschäden wie insbesondere entgangenen Gewinn.
b. Die Haftung ist gegenüber Verbrauchern außer bei vorsätzlichem oder grob fahrlässigem Verhalten oder bei Schäden aus der Verletzung von Leben, Körper und Gesundheit und der Verletzung wesentlicher Vertragspflichten (Kardinalpflichten) auf die bei Vertragsschluss typischerweise vorhersehbaren Schäden und im übrigen der Höhe nach auf die vertragstypischen Durchschnittsschäden begrenzt. Dies gilt auch für mittelbare Folgeschäden wie insbesondere entgangenen Gewinn.
c. Die Haftung ist gegenüber Unternehmern außer bei der Verletzung von Leben, Körper und Gesundheit oder vorsätzlichem oder grob fahrlässigem Verhalten des Betreibers auf die bei Vertragsschluss typischerweise vorhersehbaren Schäden und im Übrigen der Höhe nach auf die vertragstypischen Durchschnittsschäden begrenzt. Dies gilt auch für mittelbare Schäden, insbesondere entgangenen Gewinn.
d. Die Haftungsbegrenzung der Absätze a bis c gilt sinngemäß auch zugunsten der Mitarbeiter und Erfüllungsgehilfen des Betreibers.
e. Ansprüche für eine Haftung aus zwingendem nationalem Recht bleiben unberührt.""",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal),
                ),
                SizedBox(
                  height: 10,
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "3. Änderungsvorbehalt",
                  style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
                ),
                Text(
                  """a. Der Betreiber ist berechtigt, die Nutzungsbedingungen und die Datenschutzerklärung zu ändern. Die Änderung wird dem Nutzer per E-Mail mitgeteilt.
b. Der Nutzer ist berechtigt, den Änderungen zu widersprechen. Im Falle des Widerspruchs erlischt das zwischen dem Betreiber und dem Nutzer bestehende Vertragsverhältnis mit sofortiger Wirkung.
c. Die Änderungen gelten als anerkannt und verbindlich, wenn der Nutzer den Änderungen zugestimmt hat.""",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "Informationen über den Umgang mit deinen persönlichen Daten sind in der Datenschutzerklärung enthalten.",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
