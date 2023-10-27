import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Scanner;

public class fasta_all_n_filter_v2 {
	public static void main(String args[]) throws IOException {
	File text = new File(args[0]);
	Scanner inFile = new Scanner(text);
	
	//Make array lists to store lines from sequence file in
	ArrayList<String> Line1 = new ArrayList<String>();
	ArrayList<String> Line2 = new ArrayList<String>();
	
	//Separating the lines into different lists
	int nLine = -1;
    while (inFile.hasNextLine()) {
	nLine++; 	
      String first = inFile.nextLine();
      Line1.add(nLine, first);
      String second = inFile.nextLine();
      Line2.add(nLine, second);
    }
    
    //Converting the Line2 to an array to count the number of charaters in it
    String[] line2List = Line2.toArray(new String[Line2.size()]);

	char n = 'N';
  
    Character[] string_length_setup = divideChar(line2List,0);
    int string_length = string_length_setup.length;
    
    //filter out sequences that contain N's for more than half the region of interest
    ArrayList<String> finalList = new ArrayList<String>();
    for(int i =0; i < Line2.size(); i++){
    	int numN = countN(Line2.get(i),n);
    	if(numN < (string_length/2)) {
    		finalList.add(Line1.get(i));
    		finalList.add(Line2.get(i));
    	}
    }
    
    writeToFile(text,finalList);
    
	}
///////////functions start
	
//////Convert seqs to array of nucleotides
	
	public static Character [] divideChar(String [] seqs, int x){
		
		String holder = seqs[x];
		Character [] nucleotides = new Character [holder.length()];
		
		for (int i =0; i < holder.length(); i++){
			nucleotides[i] = holder.toUpperCase().charAt(i);
		}
		
		return nucleotides;

	}
	
	//count number of N's
	public static int countN(String seqs, char n){
		
		int count = 0;
		 
		for (int i = 0; i < seqs.length(); i++) {
		    if (seqs.charAt(i) == n) {
		        count++;
		    }
		}
		return count;

	}
	
	//write to file
	public static void writeToFile(File text, ArrayList<String> finalList) throws IOException{
		String fileName = text.getName();
		String cutName = fileName.substring(0, fileName.length()-21);
		
	    try {
	    FileWriter myWriter = new FileWriter(cutName+"_final.fasta");
	        for(String i: finalList) {
	        myWriter.write(i + System.lineSeparator());
	        }
	        myWriter.close();
	    }
	    	finally{	
	    	}
	 }   
}
