import java.util.*;

public class ConvexHull{

    private Point first, last;
    private int size;

    public ConvexHull(){
        first = null;
        last = null;
    }

    // Methode
    public List<Point> simpleConvex(Point[] P){

        List<Arrow> A = new ArrayList<Arrow>(); // List of candidate arrows
        List<Arrow> E = new ArrayList<Arrow>(); // List of DoublyLinkedArrows
        List<Point> S = new ArrayList<Point>(); // List of DoublyLinkedPoints
        
        // Algorithm from the lecture
        for(Point p : P){
            for(Point q : P){
                if(p.equals(q)){
                    continue;
                }else{
                    boolean valid = true;
                    Point [] R = withoutPoints(P, p, q);
                    for(Point r : R){
                        if(ifLeft(p, q, r)){
                            valid = false;
                        }
                    }
                    if(valid == true){
                        Arrow pq = new Arrow(p, q);
                        A.add(pq);
                        
                    }
                }
            }
        }
        
        // Sort the list A -> DoublyLinkedList of Arrows(E)
        int index = 0;
        E.add(A.get(index));
        while(E.size() < A.size()){
            Arrow current = E.get(index);
            for(Arrow check : A){
                if(current.getEnd().isEqual(check.getStart())){
                    E.add(check);
                    index++;
                    continue;
                }
            }
        }

        // E -> DoublyLinkedList of Points(S): 
        int merker = 0;
        Iterator<Arrow> iterator = E.iterator();
        while(iterator.hasNext()){
            if(merker%2 == 0){
                Point a = iterator.next().getStart();
                this.add(a); // links the points
                S.add(a);    // add in the output list.
            }else{
                Point a = iterator.next().getStart();
                this.add(a); // links the points
                S.add(a);
            }
        }
        // one last connection. first <-> last
        first.connectAsSucc(last);

        // show the results of DoublyLinkedList
        System.out.println("first:");
        first.show();
        first.showSucc();
        System.out.println("last:");
        last.show();
        last.showPred();

        return S;
    }

    public boolean isEmpty(){
        return size == 0;
    }
    //add
    public void add( Point p ) 
    {
        if ( isEmpty() ) {
            first = last = p;
        }else{
            last.connectAsSucc( p );
            last = p;
        }
        size++;
    }
    // size()
    public int size(){
        return size;
    }
    
    // other static methods
    public static void showAll(List<Point> E){
        Iterator<Point> iterator = E.iterator();
        System.out.println("Convex Hull coordinates: ");
        while(iterator.hasNext()){
            Point a = iterator.next();
            System.out.println("x: " + a.get(0) + " y: " + a.get(1));
        }
    }

    public static boolean hasThis(List<Point> E, Point p){
        Iterator iterator = E.iterator();
        boolean k = false;
        while(iterator.hasNext()){
            if(iterator.next().equals(p)){
                k = true;
                break;
            }
        }
        return k;
    }

    // check if r is on left or right of line pq
    public static boolean ifLeft(Point p, Point q, Point r){
        // p : start, q: end
        double d = (r.get(0) - p.get(0))*(q.get(1) - p.get(1)) - (r.get(1) - p.get(1))*(q.get(0) - p.get(0)) ;
        return d < 0;
    }

    // take p and q out, rest of the list:
    public static Point[] withoutPoints(Point [] P, Point p, Point q){
        int k = 0;
        Point [] R = new Point[P.length - 2];
        for(int i = 0; i < P.length; i++){
            if(!P[i].equals(p) && !P[i].equals(q)){
                R[k] = P[i];    
                k++;
            }
        }
        return R;
    }

    public static void main(String [] args){
        
        // MyTest1
        System.out.println("*********Test1**********");
        double [] a =  {0.0, 0.0};
        double [] b =  {1.0, 0.0};
        double [] c =  {1.0, 1.0};
        double [] d =  {0.0, 1.0};
        double [] f =  {0.1, 0.1};

        Point aa = new Point(a);
        Point bb = new Point(b);
        Point cc = new Point(c);
        Point dd = new Point(d);
        Point ff = new Point(f);

        Point [] list1 = new Point[]{aa, cc, dd, bb, ff};
        ConvexHull test1 = new ConvexHull();
        showAll(test1.simpleConvex(list1));

        // MyTest2
        System.out.println("*********Test2**********");
        double [] a1 = {10.0, 10.0};
        double [] a2 = {10.0, 100.0};
        double [] a3 = {100.0, 10.0};

        double uB = 100.0; //  upperBound
        double lB = 10.0; // lowerBound

        java.util.Random numberGenerator = new java.util.Random();
        Point [] list2 = new Point [1003];
        int i = 0;
        while(i < 1000){
            // candidates
            double rX = lB + (uB - lB) * numberGenerator.nextDouble();
            double rY = lB + (uB - lB) * numberGenerator.nextDouble();
            
            // check if they are all in the boundary:
            if(lB < rX && rX < uB && lB < rY && rY < uB && rY < (-rX + uB + lB) ){
                double [] coordinates = new double[]{rX, rY};
                Point point = new Point(coordinates);
                list2[i] = point;
                i++;
            }
        }
        Point a11 = new Point(a1);
        Point a22 = new Point(a2);
        Point a33 = new Point(a3);
        list2[1000] = a11;
        list2[1001] = a22;
        list2[1002] = a33;

        ConvexHull test2 = new ConvexHull();
        showAll(test2.simpleConvex(list2));
    }
}