public class Job implements Comparable<Job>{

    private int dauer, deadline; // endpoint = deadline

    public Job(int d, int dl){
        dauer = d;
        deadline = dl;
    }

    // benoetigte Methoden
    public int getDauer(){
        return dauer;
    }
    public int getDeadline(){
        return deadline;
    }
    public String toString(){
        return "[" + this.getDauer() + ", " + this.getDeadline() + "]";
    }

    @Override
    public int compareTo(Job other){
        // aufsteigend sortieren nach Endpunkte(Deadline)
        if(this.getDeadline() < other.getDeadline()){
            return -1;
        }else if(this.getDeadline() == other.getDeadline()){
            return 0;
        }else{ // this.getDeadline() > other.getDeadline()
            return 1;
        }
    }

}