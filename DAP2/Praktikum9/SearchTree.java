public class SearchTree{
    
    // Attributes
    private Integer content;
    private SearchTree leftChild, rightChild;
    private Integer size;

    // Konstruktoren
    public SearchTree(Integer [] a)
    {
        // den Baum initialisieren mit dem ersten Element
        content = a[0];
        leftChild = new SearchTree();
        rightChild = new SearchTree();

        // das Array hinzufuegen
        for(int i = 1; i < a.length; i++){
            this.add(a[i]);
        }
    }
    public SearchTree(){ 
        // noch eine Variante des Konstruktors, die keine Eingabe erwartet.
        content = null;
        leftChild = null;
        rightChild = null;
    }

    // Check ob der Wurzel leer ist
    public boolean isEmpty(){
        // Es soll Integer anstatt int benutzt werden, da
        // es mit null vergleichen werden kann.
        return content == null;
    }

    // Integer hinzufuegen
    public void add(Integer a)
    {
        if ( isEmpty() ){ // Wurzel leer. Einfach einfuegen.
            content = a;
            leftChild = new SearchTree();
            rightChild = new SearchTree();
        }
        else{ // Wurzel nicht leer, aber groesser als die Eingabe.
            // zum rechtChild gehen.
            if ( this.getContent() > a ){
                leftChild.add( a );
            } // nicht leer, zum leftChild gehen.
            else if ( this.getContent() < a ){
                rightChild.add( a );
            }
            else{ // das Element, was Wurzel ist, ist gleich.
                // dann size um 1 erhoehen.
                this.incrementQuantity();
            }
        }
    }

    public void incrementQuantity(){
        // size um 1 erhoehen.
        size = size + 1;
    }

    public Integer getContent(){
        // gibt den Wurzel zurueck.
        return content;
    }

    // show() Methoden: InOrder, PreOrder, PostOrder
    public void inOrderShow(){
        if ( !isEmpty() ) {
            leftChild.inOrderShow();
            System.out.println(content);
            rightChild.inOrderShow();
        }
    }
    public void preOrderShow(){
        if ( !isEmpty() ) {
            System.out.println(content);
            leftChild.preOrderShow();
            rightChild.preOrderShow();
        }
    }
    public void postOrderShow(){
        if ( !isEmpty() ) {
            leftChild.postOrderShow();
            rightChild.postOrderShow();
            System.out.println(content);
            
        }
    }

    public static void main(String [] args){

        // Array aus der Aufgabestellung
        Integer [] k = {13, 17, 5, 3, -10, 15, 100, 40, -5, 4, 12, 11};
        SearchTree testTree = new SearchTree(k);

        // Parameter Check.
        assert args.length == 1:
        "Error: please enter only one parameter"; 

        assert args[0].equals("in") || args[0].equals("pre") || args[0].equals("post"):
        "Error: please type in the type of order. This must be one of 'in', 'pre' or 'post'.";

        // Ausgeben: Show() Methoden aufrufen.
        if(args[0].equals("pre")){
            testTree.preOrderShow();
        }else if(args[0].equals("in")){
            testTree.inOrderShow();
        }else{ // postOrder
            testTree.postOrderShow();
        }
    }
}