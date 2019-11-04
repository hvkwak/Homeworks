public class Point{

    // Attributes
    private double[] coordinates;
    private int dimension;
    private Point pred, succ;

    // Constructor
    public Point(String[] values){ // values of coordinates of a point
        if(values.length >= 1){ // check if it has one or more elements
            if(isAllDouble(values)){ // everything is good to go. bring them to attributes.
                double [] memory = new double[values.length];
                for(int i = 0; i < values.length; i++){
                    memory[i] = Double.parseDouble(values[i]);
                }
                coordinates = memory;
                dimension = memory.length;
            }else{
                throw new IllegalArgumentException("Please enter the values of right type. They must be double.");
            }
        }else{
            throw new IllegalArgumentException("Please enter one or more (double)values");
        }
        pred = succ = null;
    }
    // Constructor for coordinates of double values.
    public Point(double[] values){
        if(values.length >= 1){
            coordinates = values;
            dimension = values.length;
        }else{
            throw new IllegalArgumentException("please enter one or more values!");
        }
        pred = succ = null;
    }

    // static methods
    // check if it is double.
    public static boolean isDouble(String string) {
	    try {
	        Double.valueOf(string);
	        return true;
	    } catch (NumberFormatException e) {
	        return false;
	    }
    }
    // if all values are Double?
    public static boolean isAllDouble(String [] values){
        boolean allDouble = true;
        for(int i = 0 ; i < values.length; i++){ // check if all of them are double
            if(!isDouble(values[i])){
                allDouble = false;
                break;
            }
        }
        return allDouble;
    }

    // Methode
    public void show(){
        System.out.println("current coordinates");
        System.out.println("x: " + this.get(0));
        System.out.println("y: " + this.get(1));
    }
    public void showPred(){
        System.out.println("Pred. coordinates:");
        System.out.println("x: " + this.getPred().get(0));
        System.out.println("y: " + this.getPred().get(1));
    }
    public void showSucc(){
        System.out.println("Succ. coordinates:");
        System.out.println("x: " + this.getSucc().get(0));
        System.out.println("y: " + this.getSucc().get(1));
    }
    public double get(int i){
        return coordinates[i];
    }
    public int dim(){
        return dimension;
    }
    // Methods for DoublyLinkedList
    public Point getPred(){
        return pred;
    }
    public Point getSucc(){
        return succ;
    }
    public boolean hasSucc(){
        return succ != null;
    }

    public boolean hasPred(){
        return pred != null;
    }

    public void connectAsSucc( Point e){
        disconnectSucc();
        if ( e != null ) {
            e.disconnectPred();
            e.pred = this;
        }
        succ = e;
    }
    public void disconnectPred(){
        if ( hasPred() ){
            pred.succ = null;
            pred = null;
        }
    }
    public void disconnectSucc(){
        if ( hasSucc() ) {
            succ.pred = null;
            succ = null;
        }
    }
    public void connectAsPred( Point e ){ // e is Pred.
        disconnectPred();
        if ( e != null ){
            e.disconnectSucc();
            e.succ = this;
        }
        pred = e;
    }
    public boolean isEqual(Point a){ // check if the points are equal.
        boolean valid = true;
        for(int i = 0; i < this.dim(); i++){
            if(this.get(i) != a.get(i)){
                valid = false;
            }
        }
        return valid;
    }
}