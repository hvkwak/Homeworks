import java.util.Random;

public class LCS{

    public static int [][] LCSLength(String folge1, String folge2){
        // berechnet Laengste gemeinsame Teilfolge.
        int m = folge1.length();
        int n = folge2.length();
        
        // memory Matrix mal deklarieren.
        int [][] C = new int[m+1][n+1];

        // "Randwerte" sind nicht gueltig. Auf 0 setzen.
        for(int i = 0; i < m+1; i++){
            C[i][0] = 0;
        }
        for(int j = 0; j < n + 1; j++){
            C[0][j] = 0;
        }

        // Fuer die gueltigen Werte
        for(int i = 1; i < m+1; i++){
            for(int j = 1; j < n+1; j++){
                L(folge1, folge2, C, i, j);
            }
        }
        return C;
    }

    public static void L(String folge1, String folge2, int[][] C, int i, int j){
        // C[i][j] die Länge einer längsten gemeinsamen Teilfolge von folge1 und folge2
        // bis das i-te Element von folge1 und das j-te Element von folge2.

        // Rekursiongleichung realisieren
        if(folge1.charAt(i-1) == folge2.charAt(j-1)){
            C[i][j] = C[i-1][j-1] + 1;
        }else{
            if(C[i-1][j] >= C[i][j-1]){
                C[i][j] = C[i-1][j];
            }else{ // C[i-1][j] < C[i][j-1]
                C[i][j] = C[i][j-1];
            }
        }
    }

    public static void showLCS(int[][] C, String folge1, String folge2){
        // stellt die Ergebnisse dar.
        // immer zurueckgehen von C[m][n] bis C[0][0]
        int m = folge1.length();
        int n = folge2.length();
        int k = C[m][n]; // Laenge einer laengsten Teilfolge
        char [] memory = new char[k]; // memory Array.

        while(m >= 1 && n >= 1){
            if(C[m][n] == C[m-1][n-1] + 1 && folge1.charAt(m-1) == folge2.charAt(n-1)){
                memory[k-1] = folge1.charAt(m-1); // ins Memory Array hinzufuegen.
                m--; // alle m, n, k um 1 abziehen.
                n--;
                k--;
            }else if(C[m-1][n] > C[m][n-1]){
                m--;
            }else{
                n--;
            }
        }
        // Ergebnisse darstellen:
        System.out.print("Teilfolge: ");
        for(char a : memory){
            System.out.print(a);
        }
        System.out.print(" ");
        System.out.print(" length: " + C[folge1.length()][folge2.length()]);
    }
    
    public static String randStr(int n, Random r) {
        // Random String generator aus der Aufgabestellung.
        String alphabet =
        "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";
        StringBuilder res = new StringBuilder(n);
        while (--n>=0) {
        res.append(alphabet.charAt(r.nextInt(alphabet.length())));
        }
        return res.toString();
    }

    public static boolean isInteger(String string) {
        // check if it is Integer.
	    try {
	        Integer.valueOf(string);
	        return true;
	    } catch (NumberFormatException e) {
	        return false;
	    }
	}

    public static void main(String [] args){

        assert args.length == 1 && isInteger(args[0]) && Integer.parseInt(args[0]) > 0:
        "ERROR: please enter one positive integer parameter(length of the sequence).";

        int n = Integer.parseInt(args[0]);
        Random random = new Random();
        String folge1 = new String();
        String folge2 = new String();

        // Laenge von 0 bis n 
        for(int k = 0; k < n; k++){ 

            folge1 = randStr(k, random);
            folge2 = randStr(k, random);
            System.out.print("folge1: "+folge1);
            System.out.println("");
            System.out.print("folge2: "+ folge2);

            double results = 0;

            System.out.print("n: " + (k+1) + " ");
            for(int i = 0; i < 100; i++){

                long tStart, tEnd, msecs;
                System.gc(); // garbage collector aus der Aufgabestellung

                tStart = System.currentTimeMillis(); // Beginn der Messung
                int [][] C = LCSLength(folge1, folge2);
                tEnd = System.currentTimeMillis(); // Ende der Messung
                if(i == 99){ // einmal das Ergebnis darstellen.
                    showLCS(C, folge1, folge2);
                }
                // Die Vergangene Zeit ist die Differenz von tStart und tEnd
                msecs = tEnd - tStart;
                results = results + 1000*msecs;
                if(i == 99){
                    System.out.print(" Laufzeit: " + results/1000 + " sek.");
                }
            }
            System.out.println(" ");
        }
    }
}