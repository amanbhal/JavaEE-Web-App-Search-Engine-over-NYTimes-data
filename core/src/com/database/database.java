package com.database;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.IOException;
import java.sql.*;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.HashMap;

import org.json.*;


public class database {

	public static void insertInBulk(ArrayList<String> doc_ids) throws Exception {
		try {
			Connection conn = getConnection();
			for (String doc_id : doc_ids) {
				try {
					System.out.println("Inserting Document: " + doc_id);
					PreparedStatement sqlStatement =  conn
							.prepareStatement("INSERT INTO relevance (doc_id) VALUES ('" + doc_id + "')");
					sqlStatement.executeUpdate(); // Update is to manipulate
													// data in database
				} catch (Exception ex) {
					ex.printStackTrace();
				}

				System.out.println("Insertion successfully.");
			}
		} catch (Exception e) {
			System.out.println(e.getMessage());
		} 
	}

	// To update row for corresponding doc_id
	public static void updateDocumentRatings(Connection conn, String doc_id, String columnNameToBeModified) throws Exception {
		try {
			String query = "UPDATE relevance SET " + columnNameToBeModified + " = " + columnNameToBeModified
					+ " + 1 where doc_id = '" + doc_id + "'";
			PreparedStatement sqlStatement = (PreparedStatement) conn.prepareStatement(query);
			sqlStatement.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
		} 
	}
	
	public static void updateGlobalRatings(Connection conn, int ratingValue) throws Exception {
		try {
			String query = "UPDATE global_rating SET average_rating = average_rating + '" + ratingValue +"' where id = 1";
			PreparedStatement sqlStatement = (PreparedStatement) conn.prepareStatement(query);
			sqlStatement.executeUpdate();
			System.out.println("Updated successfully.");
		} catch (Exception e) {
			System.out.println(e.getMessage());
		} 
	}
	
	public static void updateTotalHits(Connection conn) throws Exception {
		try {
			int noOfDocs = getNumberOfDocuments(conn);
			String query = "UPDATE global_rating SET total_hits = total_hits + 1 where id = 1";
			PreparedStatement sqlStatement = (PreparedStatement) conn.prepareStatement(query);
			sqlStatement.executeUpdate();
			System.out.println("Updated successfully.");
		} catch (Exception e) {
			System.out.println(e.getMessage());
		} 
	}
	public static int getNumberOfDocuments(Connection conn) throws Exception{
	int numberOfDocuments = 0;
	PreparedStatement sqlStatement = conn.prepareStatement("SELECT count(*) FROM relevance ");
	ResultSet res = sqlStatement.executeQuery();
	if(res.next()){
		numberOfDocuments = res.getInt(1);
	}
	return numberOfDocuments;
}

	public static HashMap<String,HashMap<String, Integer>> getRatingsForAllDocuments(Connection conn, ArrayList<String> doc_ids) throws Exception {
		HashMap<String,HashMap<String, Integer>> result = new HashMap<String,HashMap<String, Integer>>();
		try {
			StringBuilder query = new StringBuilder("SELECT * FROM relevance where doc_id in (");
			for( int i = 0; i < doc_ids.size() -1 ; i++){
				query.append("?,");
			}
			
			query.append("?)");
			PreparedStatement sqlStatement = conn
					.prepareStatement(query.toString());
			for(int i = 0; i < doc_ids.size() ; i++ ){
				sqlStatement.setString(i+1, doc_ids.get(i));
			}
			
			ResultSet res = sqlStatement.executeQuery();
//			System.out.println("_____Retrieving data______");
			while (res.next()) {
				HashMap<String, Integer> ratingForDoc = new HashMap<String, Integer>();
				ratingForDoc.put("five_star", Integer.parseInt(res.getString(2)));
				ratingForDoc.put("four_star", Integer.parseInt(res.getString(3)));
				ratingForDoc.put("three_star", Integer.parseInt(res.getString(4)));
				ratingForDoc.put("two_star", Integer.parseInt(res.getString(5)));
				ratingForDoc.put("one_star", Integer.parseInt(res.getString(6)));
				ratingForDoc.put("hits", Integer.parseInt(res.getString(7)));
				result.put(res.getString(1), ratingForDoc);
			}
//			System.out.println("Successfully retrieved data !!");
		} catch (Exception ex) {
          			ex.printStackTrace();
		}

		return result;
	}
	
	public static HashMap<String, Integer> getDocumentRatings(Connection conn, String doc_id) throws Exception {
		HashMap<String, Integer> result = new HashMap<String, Integer>();
		try {
			PreparedStatement sqlStatement = (PreparedStatement) conn
					.prepareStatement("SELECT * FROM relevance where doc_id = '" + doc_id + "'");
			ResultSet res = sqlStatement.executeQuery();
//			System.out.println("_____Retrieving data______");
			if (res.next()) {
				result.put("five_star", Integer.parseInt(res.getString(2)));
				result.put("four_star", Integer.parseInt(res.getString(3)));
				result.put("three_star", Integer.parseInt(res.getString(4)));
				result.put("two_star", Integer.parseInt(res.getString(5)));
				result.put("one_star", Integer.parseInt(res.getString(6)));
				result.put("hits", Integer.parseInt(res.getString(7)));
			}
//			System.out.println("Successfully retrieved data !!");
		} catch (Exception ex) {
          			ex.printStackTrace();
		}

		return result;
	}
	
	public static double getAverageRating(Connection conn) throws Exception{
		double averageRating = 0.0;
		double totalRating = 0.0;
		PreparedStatement sqlStatement = (PreparedStatement)conn.prepareStatement("SELECT average_rating FROM global_rating where id = 1");
		ResultSet res = sqlStatement.executeQuery();
//		System.out.println("Data retrieved");
		if (res.next()) {
			totalRating = Double.parseDouble(res.getString(1));
		}
		int noOfDocs = getNumberOfDocuments(conn);
		averageRating = totalRating/(double)noOfDocs;
		return averageRating;
	}
	
	public static double getTotalHits(Connection conn) throws Exception{
		double averageHits = 0.0;
		PreparedStatement sqlStatement = (PreparedStatement)conn.prepareStatement("SELECT total_hits FROM global_rating where id = 1");
		ResultSet res = sqlStatement.executeQuery();
		System.out.println("Data retrieved");
		if (res.next()) {
			  averageHits = Double.parseDouble(res.getString(1));
		}
		return averageHits;
	}

	public static ArrayList<String> getAll() throws Exception {
		ArrayList<String> result = new ArrayList<String>();
		try {
			Connection conn = getConnection();
			PreparedStatement sqlStatement = (PreparedStatement) conn.prepareStatement("SELECT * FROM relevance");
			ResultSet res = sqlStatement.executeQuery();
			System.out.println("_____Retrieving data______");
			while (res.next()) {
				System.out.println(res.getString(1) + " : " + res.getString(2));
			}
			System.out.println("Successfully retrieved data !!");
		} catch (Exception ex) {
			System.out.println(ex.getMessage());
		}

		return result;
	}

	// Inserting data to SQL
	public static void postData(String doc_id, String rating) throws Exception {
		try {
			Connection conn = getConnection();
			PreparedStatement sqlStatement = (PreparedStatement) conn.prepareStatement(
					"INSERT INTO relevance (doc_id, rating) VALUES ('" + doc_id + "','" + rating + "')");
			sqlStatement.executeUpdate(); // Update is to manipulate data in
											// database
		} catch (Exception e) {
			System.out.println(e.getMessage());
		} finally {
			System.out.println("Insereted successfully.");
		}
	}

	// Getting JDBC Connection
	public static Connection getConnection() throws Exception {
		Connection conn = null;
		try {
			String driver = "com.mysql.jdbc.Driver";
			String url = "jdbc:mysql://10.202.157.33:3306/first_database";
			String username = "root";
			String password = " ";
			Class.forName(driver);
			conn = DriverManager.getConnection(url, username, password);
			System.out.println("Successfully Connected");
		} catch (Exception e) {
			e.printStackTrace();
		}
		return conn;
	}

	static void firstTimeInsertion() {
		int i = 0;
		ArrayList<String> doc_ids = new ArrayList<String>();
		File folder = new File("/home/tyagi/git/SearchEngine_local/json_data");
		for (final File fileEntry : folder.listFiles()) {
			try {
				String filepath = fileEntry.getPath();
				String fileContent = getFileContent(filepath);
				String doc_id = getIDFromJSON(fileContent);
				doc_ids.add(doc_id);
			} catch (Exception ex) {
			}

		}
		int len = doc_ids.size();
		try {
			database.insertInBulk(doc_ids);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

	static String getIDFromJSON(String fileContent) {
		String result = "";
		
		try {
			JSONObject objJSON = new JSONObject(fileContent);
			result = (String) objJSON.get("id");

		} catch (Exception ex) {
			System.out.println(ex.getMessage());
		}
		return result;
	}

	static String getFileContent(String filepath) {
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

