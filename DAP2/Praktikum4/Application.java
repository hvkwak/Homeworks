import java.util.Random;

public class Application{
    public static void main(String [] args){ // args are coordinates

        // check if there are 6 parameters
        // or no parameters -> random number
        assert args.length == 6 || args.length == 0:
        "ERROR: please enter six parameters or null parameters." ;
        
        if(args.length == 6){ // three points of d = 2 -> Triangle 
            
            // an array of Points
            Point [] points = new Point[args.length/2];
            for(int i = 0; i < args.length; i = i+2){
                int j = i+1;

                String [] point = new String[]{args[i], args[j]};

                Point p = new Point(point);
                points[i/2] = p;
            }

            Triangle T = new Triangle(points);

            if(T.validate()){
                System.out.println(T.perimeter());
            }
        
        }else{ // args.length == 0
            System.out.println("falsch Eingabe. 6 random coordinates are generated.");
            // random numbers are used. this builds a triangle.
            java.util.Random numberGenerator = new java.util.Random();
            double lB = -1000.0; // lowerBound
            double uB = 1000.0; //  upperBound

            Point [] points = new Point[3];

            for(int i = 0; i < 3; i++){
                double randomNumberX = lB + (uB - lB) * numberGenerator.nextDouble();
                double randomNumberY = lB + (uB - lB) * numberGenerator.nextDouble();

                double [] coordinates = new double[]{randomNumberX, randomNumberY};
                Point point = new Point(coordinates);
                points[i] = point;
            }
            
            // Triangle 
            Triangle T = new Triangle(points);
            if(T.validate()){
                System.out.println(T.perimeter());
            }else{
                System.out.println("T is not a triangle.");
            }
        }
    }
}