import javax.swing.JFrame;
import javax.swing.JOptionPane;

public class Plural {
    //static String[] exceptions = {"fish", "fox", "deer", "moose", "sheep", "cattle"};

    public static void run() {
        while (true) {
      	
        	String noun = JOptionPane.showInputDialog("Enter a singular noun");
        	Object[] options = {"Continue", //0
        						"Exit"};    //1
        	
        	int n = JOptionPane.showOptionDialog(
        				new JFrame(),
        				"The plural form is \"" + makePlural(noun.toLowerCase()) + "\"",
        				"Plural Form",
        				JOptionPane.DEFAULT_OPTION,
        				JOptionPane.INFORMATION_MESSAGE,
        				null,
        				options,
        				options[1]
        			);
        	
     
        	
        	if(n == 1){
        		break;
        	}
        }
    }

    static String makePlural(String singularWord) {
        String pluralWord = "";
        int length = singularWord.length();
        String checker = singularWord.substring(0, singularWord.length() - 1);
        char lastLetter = singularWord.charAt(singularWord.length() - 1);

        if (length == 1) {
            pluralWord = singularWord + "'s";
        } else
            switch (lastLetter) {
                case 's':
                case 'x':
                case 'z':
                    pluralWord = singularWord + "es";
                    break;
                case 'e':
                  	if ((singularWord.charAt(singularWord.length() - 2) == 'f')) {
                		pluralWord = singularWord.substring(0, singularWord.length() - 2) + "ves";
                		break;
                	}
                case 'h':
                    if ((singularWord.charAt(singularWord.length() - 2) == 'c') || (singularWord.charAt(singularWord.length() - 2) == 's')) {
                        pluralWord = singularWord + "es";
                        break;
                    }
                case 'f':
                    if (isConsonant(singularWord.charAt(singularWord.length() - 2))) {
                        pluralWord = checker + "ves";
                        break;
                    }
                case 'y':
                    if (isConsonant(singularWord.charAt(singularWord.length() - 2))) {
                        pluralWord = checker + "ies";
                        break;
                    }
                case 'o':
                	if (isConsonant(singularWord.charAt(singularWord.length() - 2))) {
                        pluralWord = singularWord + "es";
                        break;
                    }
                default:
                    pluralWord = singularWord + "s";
                    break;
            }
        return pluralWord;
    }

    public static boolean isConsonant(char ch) {
        switch (Character.toLowerCase(ch)) {
            case 'a':
            case 'e':
            case 'i':
            case 'o':
            case 'u':
                return false;
            default:
                return true;
        }
    }


    public static void main(String[] args) {
        run();
    }
}
