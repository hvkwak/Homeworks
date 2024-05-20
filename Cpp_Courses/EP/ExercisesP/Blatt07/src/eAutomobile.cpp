#include <iostream>
#include "eAutomobile.hpp"

eAutomobile::eAutomobile(double max_energy, double avg_use, double load, double km, unsigned int max_speed):
    max_energy_(max_energy),
    avg_use_(avg_use),
    load_(load),
    km_(km),
    max_speed_(max_speed)
  {
    std::cout << "called a constructor!" << std::endl;
    std::cout << this->max_energy_ << std::endl;
  };

void eAutomobile::setEnergy(){
  std::cout << "type in max_energy_, double, bigger than 0, bigger than load_:" << std::endl;
  std::cin >> max_energy_;
  if (! max_energy_ || max_energy_ <= 0 || max_energy_ < load_ ) {
    std::cout << "invalid max_energy_. using standard max_energy_ value." << std::endl;
    max_energy_ = 80;
  }
}

void eAutomobile::setLoad(){
  std::cout << "type in load_, double, bigger than 0, smaller than max_energy:" << std::endl;
  std::cin >> load_;
  if (! load_ || load_ <= 0) {
    std::cout << "invalid load_. using standard load_ value." << std::endl;
    load_ = 50;
  }
  if (load_ > max_energy_){
    std::cout << "invalid load_ due to load_ > max_energy_. load_ = max_energy_." << std::endl;
    load_ = max_energy_;
  }
}

void eAutomobile::prozent(){
  std::cout << "load prozent: "<< load_ / max_energy_ << std::endl;
}

void eAutomobile::setKm(){
  std::cout << "type in km_" << std::endl;
  std::cin >> km_;
  if (! km_ || km_ < 0) {
    std::cout << "invalid km_. using standard km_ value." << std::endl;
    avg_use_ = 30000;
  }
}

void eAutomobile::setUse(){
  std::cout << "type in avg_use_" << std::endl;
  std::cin >> avg_use_;
  if (! avg_use_ || avg_use_ <= 0) {
    std::cout << "invalid avg_use. using standard avg_use value." << std::endl;
    avg_use_ = 12.5;
  }
}

void eAutomobile::setSpeed(){
  std::cout << "type in max_speed" << std::endl;
  std::cin >> max_speed_;
  if (! max_speed_) {
    std::cout << "invalid max_speed. using standard max_speed value." << std::endl;
    max_speed_ = 160;
  }
}

void eAutomobile::output(){
  std::cout << "*****************OUTPUT****************" << std::endl;
  std::cout << "max_energy: " << this->max_energy_ << std::endl;
  std::cout << "avg_use: " << this->avg_use_ << std::endl;
  std::cout << "load: " << this->load_ << std::endl;
  std::cout << "km: " << this->km_ << std::endl;
  std::cout << "max_speed: " << this->max_speed_ << std::endl;
  std::cout << "***************************************" << std::endl;
}
