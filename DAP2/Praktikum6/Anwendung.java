import java.io.BufferedReader;
import java.io.*;
import java.util.*;

public class Anwendung{

    public static ArrayList<Interval> intervalScheduling(ArrayList<Interval> intervals){
        // gibt ein moegliches IntervalScheduling der eingegebenen Intervals zurueck.
        // Annahme: Intervals sind nach ihrer Endpunkte aufsteigend sortiert.
        // Prinzip: 1. Nehme das erste Interval
        //          2. Das naechste Interval ist das Interval, das am fruehsten
        //              nach dem Ende des vorherigen Interval.
        int n = intervals.size();
        ArrayList<Interval> A = new ArrayList<Interval> ();
        A.add(intervals.get(0)); // starts with index 0.
        int j = 0;
        for(int i = 1; i < n; i++){
            if(intervals.get(i).getStart() >= intervals.get(j).getEnd()){
                A.add(intervals.get(i));
                j = i;
            }
        }
        return A;
    }

    public static int[] latenessScheduling(ArrayList<Job> jobs){
        // gibt die Endpunkte der eingegeben Aufgaben zurueck.
        // Annahme: Aufgaben sind nach ihrer Deadlines aufsteigend sortiert.
        // Prinzip: Aufgaben werden schrittweise bearbeitet.
        int n = jobs.size();
        int [] A = new int[n];
        int z = 0;
        for(int i = 0; i < n; i++){
            A[i] = z;
            z = z + jobs.get(i).getDauer();
        }
        return A;
    }
    
    // Ergebnisse Darstellung - Je nach den Eingaben
    // mit For-Schleife.
    public static void showInterval(ArrayList<Interval> A){
        System.out.print("[");
        for(int i = 0; i < A.size(); i++){
            System.out.print(A.get(i).toString());
        }
        System.out.println("]");
    }

    public static void showJob(ArrayList<Job> B){
        System.out.print("[");
        for(int i = 0; i < B.size(); i++){
            System.out.print(B.get(i).toString());
        }
        System.out.println("]");
    }

    public static void showInt(int [] A){
        System.out.print("[");
        for(int i = 0; i < A.length-1; i++){
            System.out.print(A[i] + ", ");
        }
        System.out.print(A[A.length-1]);
        System.out.print("]");
    }

    public static int maxDelay(ArrayList<Job> jobs, int [] B){
        // gibt die maximale Verspaetung zurueck.
        // Eingabe: 1. ArrayList-Jobs, das nach dem Endpunkt sortiert worden ist.
        //          2. int Array B: die Ausgabe der latenessScheduling()
        int [] delay = new int[jobs.size()];
        for(int i = 0; i < jobs.size(); i++){
            // Differenz wird eingetragen.
            // B[i]: ein Array der tatsaechlichen Endpunkte
            // jobs.get(i).getDeadline() : gewuenschte Endpunkte(Deadline)
            delay[i] = B[i] - jobs.get(i).getDeadline();
        }

        // max delay search, einmal for-Schelife durchlaufen.
        int currentMax = 0;
        for(int i = 0; i < jobs.size(); i++){
            if(currentMax < delay[i]){ 
                // Eintragen, wenn groesserer Element auftritt
                currentMax = delay[i];
            }
        }
        return currentMax;
    }

    public static void main(String [] args){

        // Assertions: Parameter Check
        assert args.length == 2 :
        "ERROR: please enter two parameters.";

        assert args[0] == "Interval" || args[0] == "Lateness":
        "ERROR: First Parameter must be 'Interval' or 'Lateness' ";

        String dir = args[1];
        String [] fileNames = new String[]{"datenBsp1.zahlen",
                                            "datenBsp2.zahlen", 
                                            "datenBsp3.zahlen",};
                                            //"datenBspVorlesung1.zahlen", 
                                            //"datenBspVorlesung2.zahlen",
                                            //"datenGross1.zahlen", 
                                            //"datenGross2.zahlen", 
                                            //"datenMittel1.zahlen",
                                            //"datenMittel2.zahlen",
                                            //"datenMittel3.zahlen",
                                            //"datenMittel4.zahlen",
                                            //"datenMittel5.zahlen"};
        if(args[0].equals("Interval")){
            for (String i : fileNames){

                // Datei-Namen ausgeben:
                System.out.println("Bearbeite Datei: " + i);
                System.out.println(" ");
                int k = 0; // Zeile-Counter
                ArrayList<Interval> A = new ArrayList<Interval>();
                
                // Datei mal einlesen
                try(BufferedReader file = new BufferedReader( new FileReader( dir + "/" + i  ) )){
                    String zeile;
                    while ((zeile = file.readLine()) != null){
                        StringTokenizer st = new StringTokenizer(zeile,",");
                        int start = Integer.parseInt(st.nextToken());
                        int ende = Integer.parseInt(st.nextToken());
                        A.add(new Interval(start, ende));
                        k++; // Zeile-Counter erhoeht um 1.
                    }
                }catch(IOException e){ // zweiter Parameter ist falsch.
                    System.out.println("ERROR: working directory not valid. please try again");
                    break;
                }

                // eingelesene Dateien ausgeben:
                System.out.println("Es wurden "+ k +" Zeilen mit folgendem Inhalt gelesen:");
                showInterval(A);

                // Nach Sortierung ausgeben:
                Collections.sort(A); // Assumption: by Interval endpoints sorted
                System.out.println(" ");
                System.out.println("Sortiert: ");
                showInterval(A);

                // Nach IntervalScheduling ausgeben:
                ArrayList<Interval> B = intervalScheduling(A);
                System.out.println(" ");
                System.out.println("Berechnetes Intervalscheduling: ");
                showInterval(B);
                System.out.println(" ");
                System.out.println("-------------------------------------");
            }
        }else{ // args[0].equals("Lateness")
            for (String i : fileNames){

                int k = 0; // Zeile-Counter
                // Datei-Namen ausgeben:
                System.out.println("Bearbeite Datei: " + i);
                System.out.println(" ");

                ArrayList<Job> A = new ArrayList<Job>();
                try(BufferedReader file = new BufferedReader( new FileReader( dir + "/" + i  ) )){
                    String zeile;
                    while ((zeile = file.readLine()) != null){
                        StringTokenizer st = new StringTokenizer(zeile,",");
                        int dauer = Integer.parseInt(st.nextToken());
                        int deadline = Integer.parseInt(st.nextToken());
                        A.add(new Job(dauer, deadline));
                        k++;
                    }
                }catch(IOException e){
                    System.out.println("ERROR: working directory not valid. please try again");
                    break;
                }

                // eingelesene Dateien ausgeben:
                System.out.println("Es wurden "+ k +" Zeilen mit folgendem Inhalt gelesen:");
                showJob(A);
                System.out.println(" ");

                // Nach Sortierung(nach dem Deadline) ausgeben:
                System.out.println("Sortiert: ");
                Collections.sort(A); 
                showJob(A);

                // Nach latenessScheduling ausgeben:
                int [] B = latenessScheduling(A);
                System.out.println(" ");
                System.out.println("Berechnetes Latenessscheduling: ");
                showInt(B);

                // maximale Verspaetung ausgeben:
                System.out.println(" ");
                System.out.println(" ");
                System.out.println("maximal delay: "+ maxDelay(A, B));
                System.out.println(" ");
                System.out.println("-------------------------------------");
            }
        }
    }
}