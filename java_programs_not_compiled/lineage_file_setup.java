import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileWriter;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Scanner;

public class lineage_file_setup {

	public static void main(String[] args) throws IOException {
		File text = new File(args[0]);
		Scanner inFile = new Scanner(text);
  		
		//Moving lines into an array list to get the length of the file
		ArrayList<String> Line1 = new ArrayList<String>();
    	int nLine = -1;
        while (inFile.hasNextLine()) {
		nLine++; 	
          String first = inFile.nextLine();
          Line1.add(nLine, first);
        }
 
        //System.out.println(Line1);
        
        String [] data_setup = new String[Line1.size()];
        for (int i = 0; i < Line1.size(); i++) {
        	data_setup[i] = Line1.get(i);
        }
        
        //Make matrix with strings separated by tab
		String [][] data = new String [data_setup.length][data_setup[0].length()];
		for(int i =0; i <data_setup.length; i++){
			data[i] = data_setup[i].toUpperCase().split("	");
		}

  		
		   
		//This prints out my imported 2D array - looks good 
		/*for (int i =0; i <data.length; i++){
		    for (int j=0; j<2; j++){
		    System.out.print(data[i][j]);
		        if (j != 2-1){    
		        System.out.print(", ");
		        }
		    }
		    System.out.println("");  
		}*/
  		
  		//Taking the second column containing the strains and putting them in their own array list.
  		ArrayList<String> strains = new ArrayList<String>();
  		for (int i =1; i < data.length; i++){
  			if(data[i]!=null)
  			strains.add(data[i][1]);
  		}
  		
  		//System.out.println(strains);
        
  		//removing duplicate strains from the array list.
  		int current = 0;
  		while (current < strains.size()) {
  			int j =0;
  			boolean isRemoved = false;
  			while (j < current) {
  				if (strains.get(current).equals(strains.get(j))) {
  					strains.remove(current);
  					isRemoved = true;
  					break;
  				}
  				else j++;
  			}
  			if (!isRemoved) current++;
  		}
        
        //System.out.println(strains);

  		for (int i=0; i < strains.size(); i++){
  			ArrayList<String> strains_hold = new ArrayList<String>();
  			for (int j=0; j < data.length; j++){	
  				if(strains.get(i).equals(data[j][1])) {
  					strains_hold.add(data[j][0]); 					
  				}
  				
  			}
  			//System.out.println(strains_hold);
			writeToFile(strains.get(i), strains_hold);
  		}
  		
  		writeFinalToFile(strains);
        
	}
	
//////Write the output to a files... Prints in a column.. 
	public static void writeToFile(String name, ArrayList<String> strains_hold) throws IOException{
		
		
	    try {
	    FileWriter myWriter = new FileWriter(name+".txt");
	    	for (int i = 0; i < strains_hold.size(); i++) {
	    		myWriter.write(strains_hold.get(i));
	    		myWriter.write(System.lineSeparator());
	    	}
	        myWriter.close();
	    }
	    	finally{	
	    	}
	 } 

	public static void writeFinalToFile(ArrayList<String> strains_names) throws IOException{
		
		
	    try {
	    FileWriter myWriter = new FileWriter("All_strain_name.txt");
	    	for (int i = 0; i < strains_names.size(); i++) {
	    		myWriter.write(strains_names.get(i));
	    		if (i<(strains_names.size()-1)) {
	    			myWriter.write(",");
	    		}
	    	}
	        myWriter.close();
	    }
	    	finally{	
	    	}
	 } 
}
