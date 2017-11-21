import java.util.Scanner;

public class Converter {
		
	public static void main(String[] args) {
		
		System.out.println("1. Binary");
		System.out.println("2. Decimal");
		System.out.println("3. Hexadecimal");
		System.out.println("4. Octal");
		
		System.out.println("Pick a program to perform: ");		
				
        Scanner scanner = new Scanner(System.in);
        String opt = scanner.next();
		int a = 0;
        switch(opt){
        case "1":
           		a = getInput("Binary", 2); 
        		
        		convert(a, 8);
        		convert(a, 10);
        		convert(a, 16);
        		
        		break;
        case "2":
        		a = getInput("Decimal", 10);
        		
        		convert(a, 2);
        		convert(a, 8);
        		convert(a, 16);
        		break;
        case "3":
	        	a = getInput("Hexadecimal", 16);
	        	
	    		convert(a, 2);
	    		convert(a, 8);
	    		convert(a, 10);
        		break;
        case "4":
	        	a = getInput("Octal", 8);
	        	
	    		convert(a, 2);
	    		convert(a, 10);
	    		convert(a, 16);
        		break;
        default:
        		System.out.println("Invalid option. Closing program...");
        		break;
        		
        }
	}	
	//getInput type
	//@option - program type binary,octal, decimal, hexadecimal;
	//@base - base of the program type
	private static int getInput(String option, int base){
		
		System.out.println("Input " + option + " number: ");
		Scanner scanner = new Scanner(System.in);
		String inputNum = scanner.next();
		
		
		if(base == 16){
	        String digits = "0123456789ABCDEF";
	        inputNum = inputNum.toUpperCase();
	        int decimal = 0;
	        for (int i = 0; i < inputNum.length(); i++) {
	            char c = inputNum.charAt(i);
	            int d = digits.indexOf(c);
	            decimal = 16*decimal + d;
	        }
	        
	        return decimal;
		} else {
			try{
				int i = Integer.parseInt(inputNum);
				if((base == 8 && isOctal(i)) || (base == 2 && isBinary(i)) || (base == 10)){
				    int decimal = 0;
				    int p = 0;
				    while(i!=0){
				          int temp = i%10;
				          decimal += temp*Math.pow(base, p);
				          i = i/10;
				          p++;
				    }
				    return decimal;
				} else {
					System.out.println("The number you entered " + i + " is not a base of " + option);
					
					System.exit(0);
					return 0;
				}

			} catch(NumberFormatException e) {
				System.out.println(e.getMessage());
				return 0;
			}
		}
	}
	
	public static boolean isBinary(int number) { int copyOfInput = number; while (copyOfInput != 0) { if (copyOfInput % 10 > 1) { return false; } copyOfInput = copyOfInput / 10; } return true; }
	public static boolean isOctal(int number) {int copyOfInput = number; while(copyOfInput!=0){if(copyOfInput%10>=8){ return false;} copyOfInput = copyOfInput/10;} return true; }
	
	public static void convert(int decimal, int base){
	    String digits = "0123456789ABCDEF";
		String out="";
		String type = "";
		
		for(;decimal>0;){
			int modulus = decimal%base;
			if(base == 16){
				out = digits.charAt(modulus) + out;
			} else {
				out = Integer.toString(modulus) + out;
			}
			decimal /= base;
		}
		
		switch(base){
		case 2:
			type = "Binary";
			break;
		case 8:
			type = "Octal";
			break;
		case 10:
			type = "Decimal";
			break;
		case 16:
			type = "Hexadecimal";
			break;
		default:
			break;
		}
		System.out.println(type + ": " + out);
	}

}
