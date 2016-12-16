import java.util.Scanner;

public class Bacon
{
  public static void main(String args[])
  {
    Scanner input = new Scanner(System.in);

    MakeSense Frank = new MakeSense();

    System.out.println("Type anything");
    String Answer = input.nextLine();

    Frank.displayMessage( Answer );
  }

}