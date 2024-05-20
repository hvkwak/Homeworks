class eAutomobile{
  
public:
  // Constructors
  eAutomobile(): max_energy_(80), avg_use_(12.5), load_(50), km_(30000), max_speed_(160) {
    setEnergy();
    setLoad(); // after setEnergy().
    setUse();
    setKm();
    setSpeed();
  }
  eAutomobile(double max_energy, double avg_use, double load, double km, unsigned int max_speed);

  // Functions
  void output();
  void setEnergy();
  void setUse();
  void setLoad();
  void setKm();
  void setSpeed();
  void prozent();
  
private:
  double max_energy_, avg_use_, load_, km_;
  unsigned int max_speed_;
};
