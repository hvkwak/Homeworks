public class EditDistance{

    public static int distance(String a, String b, boolean o){
        // 1 ≤ i ≤ n , 1 ≤ j ≤ m
        int n = a.length();
        int m = b.length();
        int [][] D = new int[n+1][m+1];

        String aa = new String(a);

        D[0][0] = 0;
        for(int i = 1; i < n+1; i++){
            D[i][0] = i;
        }
        for(int j = 1; j < m+1; j++){
            D[0][j] = j;
        }
        for(int i = 1; i < n+1; i++){
            for(int j = 1; j < m+1; j++){
                D[i][j] = minimum(D, i, j, a, b);
            }
        }
        if(o == true){
            printEditOperations(D, n, m, aa, b);
        }else{
            return D[n][m];
        }
        return D[n][m];
    }

    public static void printEditOperations(int [][] D, int n, int m, String aa, String b){
        while(D[n][m] > 0){ // n und m.
            //System.out.println("D: " + D[n][m]);
            //System.out.println("n-1: " + (n-1));
            //System.out.println("m-1: " + (m-1));

            int delete1 = D[n-1][m];
            int add1 = D[n][m-1];
            int replace1 = D[n-1][m-1];

            int [] comparison = new int[3];
            comparison[0] = delete1;
            comparison[1] = add1;
            comparison[2] = replace1;

            int current = delete1;
            // merker : operation merker
            int merker = 0;
            for(int q = 1; q < comparison.length; q++){
                if(comparison[q] <= current){
                    current = comparison[q];
                    merker = q;
                }
            }

            if(merker == 2 && (D[n-1][m-1] == D[n][m])){
                System.out.println("einfach so lassen:");
                System.out.print(aa);
                System.out.println("");
                n = n-1;
                m = m-1;
            }else{
                if(merker == 2){ // Ersetzung
                    System.out.print("Kosten 1: ");
                    //System.out.print("replace!");
                    System.out.print("Ersetze " + aa.charAt(n-1) + " durch ");
                    System.out.print(b.charAt(m-1));
                    System.out.print(" an Position"+ n + "--> ");
                    aa = replace(aa, b.charAt(m-1), n);
                    System.out.print(aa);
                    System.out.println("");
                    System.out.println("");
                    n = n-1;
                    m = m-1;
                }else if(merker == 1){ // Einfuegung
                    System.out.print("Kosten 1: ");
                    //System.out.print("add!");
                    System.out.print("Fuege " + aa.charAt(n-1) + " an Position ");
                    System.out.print(b.charAt(m-1));
                    System.out.print(n + "--> ");
                    aa = add(aa, b.charAt(m-1), n);
                    System.out.print(aa);
                    System.out.println("");
                    n = n-1;
                }else{ // AuO == 3, Loeschung
                    System.out.print("Kosten 1: ");
                    System.out.print("delete: " + aa.charAt(n-1));
                    System.out.print(" an Position " + n);
                    aa = delete(aa, n);
                    System.out.print(" "+aa);
                    System.out.println("");
                    m = m-1;
                }
            }
        }
    }

    public static String replace(String aa, char o, int i){
        char [] chars = aa.toCharArray();
        for(int k = 0; k < aa.length(); k++){
            if(i-1 == k){
                chars[k] = o;
            }
        }
        return new String(chars);
    }
    public static String add(String aa, char o, int i){
        char [] chars = aa.toCharArray();
        char [] results = new char[chars.length+1]; 
        int merker = 0;
        for(int j = 0; j < results.length; j++){
            if(i-1 == j){
                results[j] = o;
            }else{
                results[j] = chars[merker];
                merker++;
            }
        }
        return new String(results);
    }

    public static String delete(String aa, int i){
        char [] chars = aa.toCharArray();
        char [] results = new char[chars.length-1]; 
        int merker = 0;
        for(int j = 0; j < chars.length; j++){
            if(i-1 == j){
                
            }else{
                results[merker] = chars[j];
                merker++;
            }
        }
        return new String(results);
    }

    public static int minimum(int [][] D, int i, int j, String a, String b){
        // 1 ≤ i ≤ n, 1 ≤ j ≤ m
        int [] values = new int[3];
        if(a.charAt(i-1) == b.charAt(j-1)){ // falls a(i) == b(j)
            values[0] = D[i-1][j-1];
        }else{ // Ersetzung (falls a(i) != b(j))
            values[0] = D[i-1][j-1] + 1;
        }
        // Einfügung
        values[1] = D[i][j-1] + 1;
        // Löschung
        values[2] = D[i-1][j] + 1;
        
        int current = values[0];
        for(int k = 1; k < values.length; k++){
            if(values[k] < current){
                current = values[k];
            }
        }
        return current;
    }

    public static int [] minimumExtra(int [][] D, int i, int j, String a, String b){
        int [] values = new int[3];
        int [] operations = new int[3];

        if(a.charAt(i-1) == b.charAt(j-1)){ // falls a(i) == b(j)
            values[0] = D[i-1][j-1];
            operations[0] = 0;
        }else{ // Ersetzung (falls a(i) != b(j))
            values[0] = D[i-1][j-1] + 1;
            operations[0] = 1;
        }
        // Einfügung
        values[1] = D[i][j-1] + 1;
        operations[1] = 2;
        // Löschung
        values[2] = D[i-1][j] + 1;
        operations[2] = 3;


        // Start-Merker
        int current = values[0];
        int op = operations[0];

        for(int k = 1; k < values.length; k++){
            if(values[k] <= current){
                current = values[k]; // key
                op = operations[k];
            }
        }
        int [] results = new int[2];
        results[0] = current;
        results[1] = op;

        return results;
    }

    public static void main(String [] args){
        String a = "informatics";
        String b = "interpolations";
        //System.out.println(distance(a, b, false));
        distance(a, b, true);

        //System.out.println(distance(a, b, false));
        //System.out.println(distance(a, b, false));
        //System.out.println(distance(a, b, true));

        //System.out.println(add(a, 'k', 0));
        //System.out.println(delete(a, 5));
    }
}