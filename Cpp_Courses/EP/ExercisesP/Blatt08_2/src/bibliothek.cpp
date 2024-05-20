#include "../include/bibliothek.h"
#include <iostream>

using namespace std;


Bibliothek::Bibliothek()
    : _naechsteInventarnummer(1), _naechsteBenutzernummer(1) {
}


Bibliothek::~Bibliothek() {
    for (unsigned int i = 0; i < _buecher.size(); ++i) {
        delete _buecher.elementAt(i);
    }
    for (unsigned int i = 0; i < _benutzer.size(); ++i) {
        delete _benutzer.elementAt(i);
    }
}


void Bibliothek::listeBuecherAuf() {
    if (_buecher.size() == 0)
        cout << "Es wurden noch keine Buecher erfasst!" << endl;
    else{
        // Liste der Buecher durchlaufen und ausgeben
        for (unsigned int i = 0; i < _buecher.size(); ++i) {
            _buecher.elementAt(i)->print();
        }
    }
}


void Bibliothek::listeBenutzerAuf() {
    if (_benutzer.size() == 0)
        cout << "Es wurden noch keine Benutzer angemeldet!" << endl;
    else{
        // Liste der Benutzer durchlaufen und ausgeben
        for (unsigned int i = 0; i < _benutzer.size(); ++i) {
            _benutzer.elementAt(i)->print();
        }
    }
}


Benutzer* Bibliothek::findeBenutzer(unsigned int benutzernummer) {
    // Liste der Benutzer durchlaufen
    for (unsigned int i = 0; i < _benutzer.size(); ++i) {
        // i-ten Benutzer ueberpruefen ob benutzernummer uebereinstimmt
        if (_benutzer.elementAt(i)->benutzerNummer() == benutzernummer)
            return _benutzer.elementAt(i);
    }
    return nullptr;
}


void Bibliothek::anmelden(std::string name) {
    Benutzer* m = new Benutzer(name, _naechsteBenutzernummer);
    _benutzer.append(m);
    ++_naechsteBenutzernummer;
}


void Bibliothek::erfasse(std::string autor, std::string titel) {
  
  cout << "*******Start: Erfasse ein neues Buch*******" << endl;
  cout << "Autor: " << autor << "     Title: " << titel << endl;
  Buch *neues_buch = new Buch(_naechsteInventarnummer, autor, titel);

  _buecher.append(neues_buch);
  ++_naechsteInventarnummer;

  cout << "*******End: Erfasse ein neues Buch*******" << endl;
}


bool Bibliothek::rueckgabe(unsigned int inventarnummer) {

  Buch* book2return = findeBuch(inventarnummer);
  if ( book2return != nullptr) {
    // existiert das Buch mit der Inventarnummer noch
    book2return->ruekgabe();
    return true;
  } else {
    return false;
  }
}


Bibliothek::Resultat Bibliothek::ausleihe(unsigned int inventarnummer,
                                          unsigned int benutzernummer) {
  Benutzer *benutzer = findeBenutzer(benutzernummer);
  Buch *buch = findeBuch(inventarnummer);
  if (benutzer == nullptr) {
    return BENUTZER_NICHT_VORHANDEN;
  }else if (buch == nullptr) {
    return BUCH_NICHT_VORHANDEN;
  } else {
    if (buch->istVerliehen()) {
      return BUCH_AUSGELIEHEN;
    } else {
      buch->verleiheAn(benutzernummer);
      return AUSLEIHE_OK;
    }
  }
}


Buch* Bibliothek::findeBuch(unsigned int inventarnummer) {

  for (unsigned int i = 0; i < _buecher.size(); ++i) {
    if (_buecher.elementAt(i)->inventarNummer() == inventarnummer) {
      return _buecher.elementAt(i);
    }
  }
  return nullptr;
}
