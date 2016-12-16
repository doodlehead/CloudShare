import java.util.Scanner;
import java.util.Random;

public class AddQuiz
{
    public static void main(String arg[])
    {
        Scanner input = new Scanner(System.in);
        Random frank = new Random();
        System.out.println("Chose number of questions to answer!");
        double NumOfTimes = input.nextInt();
        System.out.println("Chose number range of numbers for addition questions!");
        int range = input.nextInt();
        double tempNumOfTimes = NumOfTimes;
        double TimesWrong = 0;
        double TimesRight = 0;
        double grade;

        while(tempNumOfTimes > 0)
        {
            int number1 = (frank.nextInt(range));
            int number2 = (frank.nextInt(range));

            System.out.println("What is " + number1 + " + " + number2 + "?");
            int answer = input.nextInt();
            tempNumOfTimes--;

            if(number1 + number2 == answer)
            {
                System.out.println("Correct!\n");
                TimesRight++;
            }

            else
            {
               System.out.println("Wrong!\n" + number1 + " + " + number2 + " = " +  (number1 + number2) + "\n");
               TimesWrong++;
            }

        }

        System.out.println("Horray you have finished: Frank's Addition Test!\nYour score is:\n" + TimesRight + " questions answered correctly\n" + TimesWrong + " questions answered incorrectly");
        System.out.println("Percent of success : " + (TimesRight/NumOfTimes) * 100 + "%");
        System.out.println("Percent of failure : " + (TimesWrong/NumOfTimes) * 100 + "%");
        grade = (TimesRight/NumOfTimes) * 100;
        if (grade < 60)
        {
            System.out.println("You have gotten a score below 60%  =  failure");
        }

        else
        {
            System.out.println("You have gotten a score higher than 60%, you have passed");
        }

    }

}
