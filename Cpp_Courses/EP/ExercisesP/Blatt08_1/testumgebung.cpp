#include "bibliothek.h"
#include "bibmanager.h"


int main() {
  std::string name = "Max Mustermann";
  Bibliothek bib;
  bib.anmelden(name);
  bib.listeBuecherAuf();
  bib.listeBenutzerAuf();

  
  BibliotheksManager manager(&bib);
  manager.manage();
  return 0;
}
