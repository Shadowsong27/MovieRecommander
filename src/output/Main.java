package output;

import logic.Logic;
import common.ConnectionTMDb;

import java.net.ConnectException;
import java.util.Scanner;

public class Main {

    public static void main(String[] args) {

	    Scanner scanner = new Scanner(System.in);

        System.out.println("====================================\n"
                         + "|                                  |\n"
                         + "|   Welcome to MovieRecommender    |\n"
                         + "|                                  |\n"
                         + "====================================\n");

        
        System.out.print("Please enter the API KEY: ");
        String API_KEY = scanner.nextLine();

        System.out.print("Please enter the IMDb ID: ");

        String inputID = scanner.nextLine();
        System.out.println(inputID);

        Logic logic = new Logic();
        logic.setApiKey(API_KEY);

        // Arraylist re
        System.out.println("This is the result");

    }
}
