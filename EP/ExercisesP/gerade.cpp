/*
 * gerade.cpp
 * Das Programm berechnt die Geradenparameter~$m, b$ fuer die Geradengleichung
 * f(x) = mx + b 
 * Als Eingabe dienen die Punkte (x1, y1), (x2, y2)
 */

#include<iostream>
using namespace std;

int main() {
  double x1, y1, x2, y2, m, b, x3, y3;


  //++++++++++++++++++++++++++++++++++++++++++++
  // Hier bitte die Werte ueber Tastatureingaben 
  // einlesen:
  cout << "Bitte geben Sie 2 Punkte Koordinaten: x1, y1, x2, y2" << endl;

  cin >> x1 >> y1 >> x2 >> y2 ; 
  //++++++++++++++++++++++++++++++++++++++++++++
  cout << "Hier sind 4 eingelesenen Werte: " << x1 << ", "<< y1 << ", " << x2 << ", " << y2 << endl;


  //++++++++++++++++++++++++++++++++++++++++++++
  // Hier bitte die Berechnungsfolge einfuegen:

  // Check first if we can define a line with these two points:
  if (x1 == x2 && y1 == y2){
    cout << "the two points are identical. A line cannot be defined" << endl;
    return 0;
  }else if (x1 == x2 && y1 != y2){
    cout << "y = " << x1 << endl;
    return 0;
  }else if (x1 != x2 && y1 == y2){
    cout << "x = " << y1 << endl;
    return 0;
  }else{
    m = (y1 - y2) / (x1 - x2);
    b = y1 - m*x1;
  }
  //++++++++++++++++++++++++++++++++++++++++++++
  cout << "Die Gerade hat folgende Gleichung: f(x) = " << m << " * x + " << b << endl;


  /*
  c) Erweitern Sie den Code so, dass zusätzlich überprüft werden soll, ob ein dritter Punkt auf der bereits berech-
  neten Gerade liegt. Überprüfen Sie den Code, indem Sie zu allen berechneten Geraden aus Teil a) bestimmen,
  ob der Punkt (3, 4) auf der Gerade liegt. Geben Sie dazu die Meldung „Der Punkt (3, 4) liegt [nicht] auf der
  Geraden“ aus, je nachdem ob der Punkt auf der Geraden liegt oder nicht.
  */
  cout << "Geben Sie einen Zusatzpunkt ein." << endl;
  cin >> x3 >> y3 ;
  if (y3 == m*x3+b){
    cout << "y3: " << y3 << ", m*x3+b : " << m*x3+b << endl;
    cout << " Der Punkt" <<  x3 << ", " << y3 << "liegt auf der Geraden " << endl;
  }else{
    cout << "y3: " << y3 << ", m*x3+b : " << m*x3+b << endl;
    cout << " Der Punkt" <<  x3 << ", " << y3 << "liegt nicht auf der Geraden " << endl;
  }



  return 0;
}
