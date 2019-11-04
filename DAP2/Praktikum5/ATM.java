public class ATM{

    // static methods
    
    public static int[] change(int b, int[] w){ 
        // returns how many each type of bill is used.
        int [] output = new int [w.length]; // output array declaration
        for(int i = 0; i < w.length; i++){ // for loop: each bill
            while(b - w[i] >= 0){ // while loop: take as many bigger bills as possible
                b = b - w[i]; // amount update
                output[i]++; // output array update.
            }
        }
        return output;
    }

    public static boolean isInteger(String string) {
	    try { // try to see if the string parameter has the value of integer
	        Integer.valueOf(string); // when no error
	        return true; // return true
	    } catch (NumberFormatException e) { // otherwise, return error.
	        return false;
	    }
    }

    public static void main(String [] args){
        assert args.length == 2:
        "ERROR: please enter two parameters. ";

        assert args[0].equals("Euro") || args[0].equals("Alternative"):
        "ERROR: first parameter: String, 'Euro' or 'Alternative' ";

        assert isInteger(args[1]) && Integer.parseInt(args[1]) > 0:
        "second parameter: positive integer, the amount of the change. ";

        int [] w; // collection of money declaration

        if(args[0].equals("Euro")){
            w = new int []{200, 100, 50, 20, 10, 5, 2, 1}; // bills update
        }else{ // args[0].equals("Alternative")
            w = new int [] {200, 100, 50, 20, 10, 5, 4, 2, 1}; // bills update
        }
        
        // see how many each type of bill is used
        int [] results = change(Integer.parseInt(args[1]), w);
        
        // results
        for(int i = 0; i < results.length; i++){
            System.out.println("Schein: " + w[i] + " Anzahl: " + results[i]);
        }
    }
}