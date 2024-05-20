#include "benutzer.h"
#include "bibliothek.h"
#include "bibmanager.h"


int main() {

  // 8-b
  std::string Person1 = "Max Mustermann";
  std::string Person2 = "Johannes Zimmermann";
  Bibliothek bib;
  bib.erfasse("Thomas Mueller", "Tempo");
  bib.erfasse("Julian Schneider", "ADAC");
  bib.anmelden(Person1);
  bib.anmelden(Person2);

  // 8-h
  Buch *buch1 = bib.findeBuch(1);
  Benutzer *benutzer1 = bib.findeBenutzer(1);
  buch1->print();
  benutzer1->print();
  bib.ausleihe(buch1->inventarNummer(), benutzer1->benutzerNummer());
  bib.rueckgabe(buch1->inventarNummer());
  
  // liste auf Buecher und Benutzxer
  bib.listeBuecherAuf();
  bib.listeBenutzerAuf();
  bib.rueckgabe(1);

  BibliotheksManager manager(&bib);
  manager.manage();
  return 0;
}
