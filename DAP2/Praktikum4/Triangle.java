public class Triangle extends Simplex{

    public Triangle(Point [] points){
        super(points);
    }

    public boolean validate(){
        if(dim() == 2){
            return true;
        }else{
            return false;
        }
    }
    
}