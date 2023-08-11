package cup.example;

import java_cup.runtime.*;

public class Driver {

	public static void main(String[] args) throws Exception {
		
		try {
//		long startTime=0;
//		long endTime=0;
//		long resultTime=0;
//		startTime = System.nanoTime();
		Parser parser = new Parser(args[0]);
		//System.out.println(args[0]);
		parser.parse();
		//System.out.println("Finished...");
//		endTime = System.nanoTime();
//		resultTime = endTime - startTime;
//		System.err.println(resultTime);
		}
		catch (Exception e) {
			
			System.err.println(e.getMessage());
		}
	}
	
}