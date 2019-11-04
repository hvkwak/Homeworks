public abstract class Simplex extends EuclidDistance{

    // Att.
    private int dimension;
    private Point [] ps; // array of points, a point is d-dim.

    // Constructor
    public Simplex(Point [] points){
        // d+1 points
        // d-dimensional
        ps = points;
        dimension = points.length - 1;
    }

    //Methode
    public Point get(int i){
        if(0 <= i && i <= ps.length - 1){
            return ps[i];
        }else{
            throw new IllegalArgumentException("please enter the right i.");
        }
    }
    public int dim(){
        return dimension;
    }
    // below could be defined in class Triangle
    public abstract boolean validate(); 

    // returns perimeter based on euclidean distance
    public double perimeter(){
        double memory = 0;
        for(int i = 0; i < ps.length; i++){ // a point selection
            for(int j = i+1; j < ps.length; j++){ // another point selection
                memory = memory + distance(ps[i], ps[j]);
            }
        }
        return memory;
    }
}