#include "buch.h"
#include <iostream>

Buch::Buch(unsigned int inventory_number, std::string author, std::string title):
  inventory_number(inventory_number),
  author(author),
  title(title),
  user_number(0)
{    
}

unsigned int Buch::inventarNummer(){
  return inventory_number;
}

unsigned int Buch::ausgeliehenVon(){
  return user_number;
}

bool Buch::istVerliehen(){return user_number != 0;}

bool Buch::verleiheAn(unsigned int benutzernummer){
  if (user_number == 0){
    return false;
  }else {
    user_number = benutzernummer;
    return true;
  }
}

void Buch::ruekgabe(){
  user_number = 0;
}

void Buch::print(){
  std::string status = user_number == 0 ? "available": "ausgeliehen von Benutzer" + std::to_string(user_number);
  std::cout << "Buch - Inventarnummer ";
  std::cout << inventory_number;
  std::cout << ": ";
  std::cout << title;
  std::cout << " von";
  std::cout << author;
  std::cout << ",";
  std::cout << status;
}
