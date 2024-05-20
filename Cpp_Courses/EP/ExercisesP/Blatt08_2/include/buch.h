#pragma once

#include <string>


class Buch {
  
public:
  Buch(unsigned int inventory_number, std::string author, std::string title);
  // Buch();
  // ~Buch();
  bool istVerliehen();
  bool verleiheAn(unsigned int benutzernummer);
  unsigned int inventarNummer();
  unsigned int ausgeliehenVon();
  void ruekgabe();
  void print();

  
private:
  unsigned int inventory_number;
  unsigned int user_number;
  std::string author;
  std::string title;
};
