public class BubbleSort {

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
	
	public static int[] startArray(int n) {
		
		int [] values = new int[n];
		for(int i = 0; i  < n; i++) {
			values[i] = n - i;
		}
		return values;
	}
	
	public static void show(int[] array) {
		for(int i = 0; i < array.length; i++) {
			System.out.println(array[i]);
		}
	}
	
	public static void main(String[] args) {
		
		// Start Array: ein absteigend sortierter Array
		int [] values = startArray(50000);
		
		// runtime starts here
		long tStart, tEnd, msecs;
					
		// Beginn der Messung
		tStart = System.currentTimeMillis();
		bubbleSort(values);
		
		// Ende der Messung
		tEnd = System.currentTimeMillis();
		
		// Die vergangene Zeit ist die Differenz von tStart und tEnd
		msecs = tEnd - tStart;
		
		System.out.println(msecs/1000.0 + "/sec");
	}
}