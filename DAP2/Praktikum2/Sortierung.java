import java.util.Random;

public class Sortierung {
    
	// insertionSort
	public static void insertionSort(int[] array) {				
		int key;
		int i;
		for (int j = 1; j < array.length; j++) {
			key = array[j];
			i = j - 1;
			while ( i > -1 && array[i] > key) {
				array[i+1] = array[i];
				i = i - 1;
			}
			array[i+1] = key;
		}
	}
	// Check if it is sorted.
	public static boolean isSorted(int[] array) {
		for(int i = 0; i < array.length - 1; i++) {
			if(array[i] > array[i+1]) {
				return false;
			}
		}
		return true;
	}
	
	// Show the elements of the array, at most 100 Elements
	public static void show(int[] array) {
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
	
	// Check if Integer
	public static boolean isInteger(String string) {
	    try {
	        Integer.valueOf(string);
	        return true;
	    } catch (NumberFormatException e) {
	        return false;
	    }
	}
	
	// MergeSort aus der Vorlesung
	public static void mergeSort(int[] array) { // Initialisierung
		int [] tmpArray = new int[array.length];
		mergeSort(array, tmpArray, 0, array.length-1);
		assert isSorted(array);
	}
	public static void mergeSort(int[] array, int[] tmpArray, int left, int right) {
		if(left < right) {
			int q = (left+right)/2;
			mergeSort(array, tmpArray, left, q);
			mergeSort(array, tmpArray, q+1, right);
			merge(array, tmpArray, left, q, right);
		}
	}
	public static void merge(int [] array, int[] tmpArray, int left, int q, int right) {
		// sizes of two subarrays to be merged
        int n1 = q - left + 1; 
        int n2 = right - q;
  
        // Create temp arrays and copy data into them
        int L[] = new int [n1]; 
        int R[] = new int [n2]; 
        for (int i=0; i<n1; ++i) {L[i] = array[left + i];} 
        for (int j=0; j<n2; ++j) {R[j] = array[q + 1+ j];} 

        /// Merge the temp arrays  
        // Initial indexes of first and second subarrays 
        int i = 0, j = 0; 

        // Initial index of merged subarry array 
        int k = left; 
        while (i < n1 && j < n2){ // both of them are good to go. 
            if (L[i] <= R[j]) { 
                array[k] = L[i]; 
                i++; 
            }else{ 
                array[k] = R[j]; 
                j++; 
            } 
            k++; 
        }
        /// Copy remaining elements of L[] and R[]
        while (i < n1) { 
            array[k] = L[i]; 
            i++; 
            k++;
        }
        while (j < n2) { 
            array[k] = R[j]; 
            j++; 
            k++; 
        }
	}
	
	// Main Methode
	public static void main(String [] args) {
		
		// Assertions: Inputs check if they are right
		assert args.length >= 1 && args.length <= 3 : 
			"ERROR: please enter at least one parameter. " +
			"First parameter: the number of random numbers. " +
			"(optional)Second parameter: the art of Sort(insert or merge, default: merge)"+
			"(optional)Third parameter: order of sort(auf, ab, rand, default: auf)";
		
		assert isInteger(args[0]) && Integer.parseInt(args[0]) > 0 : 
			"ERROR: the first parameter must be a positive integer!";
		
		// Random Number Generator: Input Array
		java.util.Random numberGenerator = new java.util.Random();
		int length = Integer.parseInt(args[0]);
		
		// get ready to remember results each loop.
		int loops = 100; // for consistency, let's say 100 times.
		double [] results = new double[loops];
		
		// write the runtime into the results array each loop
		for(int loop = 0; loop < loops; loop++) {
			
			// ZZ: an array of random numbers
			int [] ZZ = new int[length];
			for(int i = 0; i < length; i++) {
				ZZ[i] = numberGenerator.nextInt();
			}
			
			// runtime starts here
			long tStart, tEnd, msecs;
			tStart = System.currentTimeMillis();
			
			// Sort
			if(args.length == 1) { // default, merge && aufsteigend.
				mergeSort(ZZ);
			}else if(args.length == 2) { // merge or insert
				assert args[1].equals("insert") || args[1].equals("merge"):
					"Error: please type in correctly. It has to be "+
					"insert or merge";
				if(args[1].equals("merge")) {
					mergeSort(ZZ);
				}else {
					insertionSort(ZZ);
				}
			}else { // args.length == 3
				if(args[2].equals("rand")) { // if random, just leave it.
					
				}else { // not random
					assert args[1].equals("insert") || args[1].equals("merge"):
						"Error: please type in correctly. It has to be"+
						"insert or merge";
					assert args[2].equals("auf") || args[2].equals("ab"): 
						"ERROR: please enter one of the following parameters: auf, ab, bzw. rand to choose the art of sort.";				
					if(args[1].equals("insert")) { 
						insertionSort(ZZ); // first insert
					}else { // or merge
						mergeSort(ZZ);
					}
					// and then "auf/absteigend sortieren"
					if(args[2].equals("ab")) { // if "ab", absteigend.
						for(int i = 0; i < length/2; i++) {
							int first = ZZ[i];
							ZZ[i] = ZZ[length-i-1];
							ZZ[length-i-1] = first;
						}
					} // if "auf", then just leave it, it is already sorted.
				}
			}
			// runtime ends here
			tEnd = System.currentTimeMillis();
			
			// Differenz von tStart und tEnd
			msecs = tEnd - tStart;
			results[loop] = msecs; // Ergebnis eintragen
			
			// als Beispiel, das erste Ergebnis darstellen
			if(loop == 0) {
				show(ZZ);
				// korrekt aufsteigend sortiert?
				if(isSorted(ZZ)) {
					System.out.println("Feld sortiert!");
				}else {
					System.out.println("Fled Nicht Sortiert!");
				}
			}
		}
		// mean value of runtime
		// Hello world!
		double sum = 0;
		for(int i=0; i < results.length; i++) {
			sum = sum + results[i];
		}
		System.out.println("Durchshnittlich gedauert: ");
		System.out.println(sum/results.length);
	}
}
