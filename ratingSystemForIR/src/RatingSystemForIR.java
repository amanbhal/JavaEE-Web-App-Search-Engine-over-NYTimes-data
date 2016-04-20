import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.IOException;
import java.util.ArrayList;

import org.json.*;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
public class RatingSystemForIR {

	public static void main(String[] args) {
		// TODO Auto-generated method stub
		int i = 0;
		ArrayList<String> doc_ids = new ArrayList<String>();
		File folder = new File("/home/tyagi/git/SearchEngine_local/json_data");
		for (final File fileEntry : folder.listFiles()) {
				try{
		            String filepath = fileEntry.getPath();
		            String fileContent = getFileContent(filepath);
		            String doc_id = getIDFromJSON(fileContent);
		            doc_ids.add(doc_id);	  
				}
				catch(Exception ex){}
	            
	    }
		int len = doc_ids.size();
		try {
			database.updateInBulk(doc_ids, "0");
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
//		String filepath = "/home/tyagi/workspace/ratingSystemForIR/src/test_data/A Host of Tiles for All Inclinations.json";
//		String fileContent = getFileContent(filepath);
////		System.out.println(fileContent);
//		String doc_id = getIDFromJSON(fileContent);
//		System.out.println(doc_id);
		
	}
	
	static String getIDFromJSON(String fileContent){
		String result = "";
		JSONParser parser = new JSONParser();
		try{
			JSONObject objJSON = (JSONObject) parser.parse(fileContent);
			result = (String) objJSON.get("id");
			
		}
		catch(Exception ex){
			System.out.println(ex.getMessage());
		}
		return result;
	}
	static String getFileContent(String filepath){
		String result = "";
		BufferedReader br = null;
		try {
			br = new BufferedReader(new FileReader(filepath));
			String line = br.readLine();
			result += line;
			line = br.readLine();

		} catch (Exception e) {
			System.out.println("Error while reading the file. Error: " + e.getMessage());
			e.printStackTrace();
		} finally {
			if (br != null) {
				try {
					br.close();
				} catch (IOException e) {
					System.out.println("Error while reading the file. Error: " + e.getMessage());
					e.printStackTrace();
				}
			}
		}
		
		result = result.trim();
		return result;
	} 

}
