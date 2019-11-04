public class GeometricSearch {
	
	public static void bubbleSort(int[] array) {
		int n = array.length;
		for(int i = 0; i < n; i++) {
			for(int j = n-1; i < j; j--) {
				if(array[j-1] > array[j]) {
					int tmp = array[j];
					array[j] = array[j-1];
					array[j-1] = tmp;
				}
			}
		}
	}
	
	public static int binarySearch(float time, int GA, int GE) {
		long msecs;
		long tStart, tEnd;
		int middle = (GA+GE)/2;

		tStart = System.currentTimeMillis();
		bubbleSort(startArray(middle));
		tEnd = System.currentTimeMillis();
		msecs = tEnd - tStart;
		
		if(Math.abs(GA - GE) < 500) {
			return GA;
		}else {
			if (msecs < time) {
				return binarySearch(time, (GA+GE)/2, GE);
			}else{
				return binarySearch(time, GA, (GA+GE)/2);
			}
		}
	}
	// Please note: java index
	
	// Check if Float
	public static boolean isFloat(String string) {
	    try {
	        Float.valueOf(string);
	        return true;
	    } catch (NumberFormatException e) {
	        return false;
	    }
	}
	
	public static int[] startArray(int n) {
		// absteigend start Array generieren
		int [] values = new int[n];
		for(int i = 0; i  < n; i++) {
			values[i] = n - i;
		}
		return values;
	}
	
	public static void main(String[] args) {
		
		// Assertions: input check
		assert args.length == 1 && isFloat(args[0]) && Float.parseFloat(args[0]) > 0 : 
			"ERROR: please enter only one parameter that is float, positive " ;
		
		float time = Float.parseFloat(args[0]);
		int size = 500;
		
		int [] values = startArray(size);
		
		// runtime parameters:
		long msecs = 0;
		long tStart, tEnd;
		
		while( msecs < time ) {
			
			size = 2*size;
			values = startArray(size);
			
			// Zeitmessung
			tStart = System.currentTimeMillis();
			bubbleSort(values);
			tEnd = System.currentTimeMillis();
			msecs = tEnd - tStart;
			
			// see if it terminates
			if(Math.abs(msecs - time) < 0.1) {
				System.out.println("TERMINATE.");
				System.out.println("size: " + size);
				break;
			}
			
			// results
			System.out.println("");
			System.out.print("Array size: " + size);
			System.out.print(" // msecs: " + msecs);
			
		}

		System.out.println("");
		System.out.println(" array size searched by binarySearch() is approximately.. ");
		System.out.print(binarySearch(time, size/2, size));
		System.out.println("");
		
	}
}