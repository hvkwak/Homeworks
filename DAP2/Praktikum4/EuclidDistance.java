public class EuclidDistance implements Distance{
    
    // returns Euclidean distance between two points:
    public double distance(Point p1, Point p2){
        int d = p1.dim();
        double diff = 0;
        for(int k = 0; k < d; k++){ // k of dimension
            double D = p1.get(k) - p2.get(k);
            diff = diff + D*D;
        }
        return java.lang.Math.sqrt(diff); 
    }
}