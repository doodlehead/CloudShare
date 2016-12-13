public class AutomobileTest
{
    public static void main(String args[])
    {
        Automobile auto1 = new Automobile();
        System.out.println("Auto 1: " + auto1.toString());

        Automobile auto2 = new Automobile(true, "green", 37000);
        auto2.name = "INGRID";
        System.out.println("Auto 2: " + auto2.toString());

        System.out.println("Driving Auto 1...");
        auto1.drive();
        System.out.println("Driving Auto 2...");
        auto2.drive();

        System.out.println("Giving Auto 1 a paint job...");
        auto1.setColor("red");
        System.out.println("Auto 1 is now " + auto1.getColor());
        System.out.println("Renaming Auto 1...");
        auto1.name = "CHRISTINE";
        System.out.println("Auto 1 is named " + auto1.name);

        System.out.println("Shutting off Auto 2...");
        auto2.shutOff();
        System.out.println("Shutting off Auto 2 AGAIN...");
        auto2.shutOff();

        System.out.println("Auto 1: " + auto1.toString());
        System.out.println("Auto 2: " + auto2.toString());

    }

}