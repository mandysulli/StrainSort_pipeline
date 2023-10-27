import java.io.File;
import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileWriter;
import java.io.FilterReader;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Scanner;

public class scaffold_joining {
	public static void main(String[] args) throws IOException {
		File samFile = new File(args[0]); 
		int genomePosition1 = Integer.parseInt(args[1]);  //first genome position to extract from
		int genomePosition2 = Integer.parseInt(args[2]); //second genome position to extract from
		int genomeSize = Integer.parseInt(args[3]); //size of reference genome
		
		String [][] importedSAM = readSAM(samFile);
		//print sam file matrix
		/*for (int i =0; i <importedSAM.length; i++){
			for (int j=0; j<importedSAM[0].length; j++){
			System.out.print(importedSAM[i][j]);
				if (j != importedSAM[0].length-1){    
				System.out.print(", ");
				}
			}
			System.out.println("");  
		}*/
		
		Character [] baseGenome = new Character [genomeSize];
		
		int[] mappedPositions = pullMappedPositions(importedSAM);
		//System.out.println(Arrays.toString(mappedPositions));
		
		String[] seqs = pullSeqs(importedSAM);
		//System.out.println(Arrays.toString(seqs));
		
		//Character[] test = divideChar(seqs,3);
		//System.out.println(Arrays.toString(test));
		
		for(int i =0; i < mappedPositions.length; i++){
			int ps = mappedPositions[i];
			Character[] seqChar = divideChar(seqs,i);
			//System.out.println(Arrays.toString(seqChar));
			for(int j = 0; j < seqChar.length; j++){
				baseGenome[ps+j] = seqChar[j];
				

				}
			}
		String n = "N";
		for(int i =0; i < baseGenome.length; i++){
			if (baseGenome[i] == null) {
				baseGenome[i] = n.charAt(0);
			} else continue;
		}
		//System.out.println(Arrays.toString(baseGenome));
		
		Character [] extractedRegion = new Character[genomePosition2 - genomePosition1];
		for(int i =0; i < extractedRegion.length; i++){
			extractedRegion[i] = baseGenome[genomePosition1+i];
		}
		//System.out.println(Arrays.toString(extractedRegion));
		
		writeToFile(samFile,extractedRegion);
	}
		
/////////////Functions Start//////////////////		
	
//////Read in sam file, remove header and put info into matrix	
	public static String[][] readSAM(File text) throws IOException{
			Scanner inFile = new Scanner(text);
			
			
			//Gets lines
			ArrayList<String> textData = new ArrayList<String>();
	    	int nLine = -1;
	        while (inFile.hasNextLine()) {
	    		nLine++; 	
	              String first = inFile.nextLine();
	              textData.add(nLine, first);
	        }
	        
			ArrayList<String> textImproved = new ArrayList<String>();
			
			//remove header by removing lines that start with @
			textData.removeIf(n -> (n.charAt(0) == '@'));
			
			// Put info from samfile into matrix
			String[][] samData = new String [textData.size()][11];
			
			for (int i = 0; i < textData.size(); i++){
				String row = textData.get(i).toString();
				String[] col = row.split("	");
					for (int j=0; j<col.length && j<11; j++){
						samData[i][j] = col[j];
				       } 
				 }
		

			return samData;
		
	}
	
//////Get positions
	
	public static int [] pullMappedPositions(String [][] importedSAM){
		
		int [] mappedPositions = new int [importedSAM.length];
		
		for (int i =0; i <importedSAM.length; i++){
			mappedPositions[i] = Integer.parseInt(importedSAM[i][3]);
		}
		
		return mappedPositions;

	}
	
//////Get seq
	
	public static String [] pullSeqs(String [][] importedSAM){
		
		String [] seqs = new String [importedSAM.length];
		
		for (int i =0; i <importedSAM.length; i++){
			seqs[i] = importedSAM[i][9];
		}
		
		return seqs;

	}
	
//////Convert seqs to array of nucleotides
	
	public static Character [] divideChar(String [] seqs, int x){
		
		String holder = seqs[x];
		Character [] nucleotides = new Character [holder.length()];
		
		for (int i =0; i < holder.length(); i++){
			nucleotides[i] = holder.toUpperCase().charAt(i);
		}
		
		return nucleotides;

	}
	
//////Write the output to a file... Prints in a column.. 
	public static void writeToFile(File samFile, Character[] extractedRegion) throws IOException{
		
		String fileName = samFile.getName();
		String cutName = fileName.substring(0, fileName.length()-4);
		String header = ">"+cutName;
		
		
	    try {
	    FileWriter myWriter = new FileWriter("Extracted_"+cutName+".fasta");
	    	myWriter.write(header);
	    	myWriter.write(System.lineSeparator());
	    	for (int i = 0; i < extractedRegion.length; i++) {
	    		myWriter.write(extractedRegion[i]);

	    	}
	    	myWriter.write(System.lineSeparator());
	        myWriter.close();
	    }
	    	finally{	
	    	}
	 } 
	
}
