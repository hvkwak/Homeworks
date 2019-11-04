import java.util.Random;

public class QuickSort{

    // Att.
    private int [] A; // original random array

    // Constructors
    public QuickSort(int k){ // k = size of the array
        java.util.Random numberGenerator = new java.util.Random();
    
        // random numbers generation
        int [] memory = new int[k];
        for(int i = 0; i < k; i++){
            memory[i] = numberGenerator.nextInt(1000);
        }
        A = memory;
    }

    public QuickSort(QuickSort memory){ 
        // copies the QuickSort object "memory" for further algorithm comparison
        A = new int[memory.getArray().length];
        for(int i=0; i < memory.getArray().length; i++){
            A[i] = memory.getArray()[i];
        }
    }

    // class methods
    public int [] getArray(){ // returns the array attribute.
        return A;
    }

    // static methods
    public static void show(int[] array) { // shows the first 100 elements of the array.
		int length;
		if(array.length > 100) {
			length = 100;
		}else {
			length = array.length;
		}
		for(int i = 0; i < length; i++) {
			System.out.println(array[i]);
		}
    }
    
    public static boolean isInteger(String string) { // check if the string has integer values.
	    try { // try to see if the parameter has value of integers.
	        Integer.valueOf(string); // if no error pops up -> return true
	        return true;
	    } catch (NumberFormatException e) { // Error
	        return false;
	    }
    }
    // Algorithm aus der Vorlesung
    public static void quickSort(int [] arr, int l, int r){
        if(l < r){
            int i = l;
            int j = r;
            int pivot = arr[(l+r)/2];
            while(i <= j){
                while(arr[i] < pivot){
                    i = i + 1;
                }
                while(arr[j] > pivot){
                    j = j - 1;
                }
                if(i <= j){
                    int tmp = arr[i];
                    arr[i] = arr[j];
                    arr[j] = tmp;
                    i = i + 1;
                    j = j - 1;
                }
            }
            quickSort(arr, l, j);
            quickSort(arr, i, r);
        }
    }

    public static void main(String [] args){

        assert args.length == 1 && isInteger(args[0]):
        "ERROR: please enter only one integer, this will be the size of the array.";

        // test list: several sort algorithms
        String [] tests = new String []{"BubbleSort()", "MergeSort()", "QuickSort()", "InsertionSort()"};
        long tStart, tEnd, msecs; // variables for Runtime check
        
        // Test Data
        QuickSort test1 = new QuickSort(Integer.parseInt(args[0]));

        for(String i : tests){ // take one sort algorithm from the test list.
            
            QuickSort current = new QuickSort(test1); // copy the original test data.

            // runtime starts here
            tStart = System.currentTimeMillis();

            if(i.equals("BubbleSort()")){ // O(n)
                BubbleSort.bubbleSort(current.getArray());
            }else if(i.equals("MergeSort()")){ // O(nlogn)
                Sortierung.mergeSort(current.getArray());
            }else if(i.equals("QuickSort()")){ // O(nlogn)
                quickSort(current.getArray(), 0, current.getArray().length - 1);
            }else{ // insertionSort() Worst: O(n^2) - Best: O(n)
                Sortierung.insertionSort(current.getArray());
            }

            // runtime ends here
            tEnd = System.currentTimeMillis();
            msecs = tEnd - tStart;

            // show results
            System.out.println(i + " Runtime: " + msecs);
            System.out.println(" isSorted: " + Sortierung.isSorted(current.getArray()));
        }
    }
}