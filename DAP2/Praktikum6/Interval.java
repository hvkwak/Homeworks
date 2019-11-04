public class Interval implements Comparable<Interval>{

    private int start, end;

    public Interval(int s, int e){
        start = s;
        end = e;
    }

    // benoetigte Methoden
    public int getStart(){
        return start;
    }
    public int getEnd(){
        return end;
    }
    public String toString(){
        return "[" + this.getStart() + ", " + this.getEnd() + "]";
    }

    @Override
    public int compareTo(Interval other){ 
        // aufsteigend sortieren nach Endpunkte
        if(this.getEnd() < other.getEnd()){
            return -1;
        }else if(this.getEnd() == other.getEnd()){
            return 0;
        }else{ // this.getEnd() > other.getEnd()
            return 1;
        }
    }
}
