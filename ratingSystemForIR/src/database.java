import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.util.ArrayList;

import com.mysql.jdbc.PreparedStatement;

public class database {


	public static void updateInBulk(ArrayList<String> doc_ids, String rating) throws Exception{
		try{
			Connection conn = getConnection();
			for(String doc_id : doc_ids){
				try{
				System.out.println("Inserting Document: " + doc_id);
				PreparedStatement sqlStatement = (PreparedStatement) conn.prepareStatement("INSERT INTO relevance (doc_id, rating) VALUES ('"+ doc_id +"','"+ rating+"')");
				sqlStatement.executeUpdate(); //Update is to manipulate data in database
				}catch (Exception ex){
					
				}
			}
		}catch (Exception e){
			System.out.println(e.getMessage());
		}
		finally {
			System.out.println("Insertion successfully.");
		}
	}
	//To update rating for corresponding doc_id
	public static void update(String doc_id, String rating) throws Exception{
		try{
			Connection conn = getConnection();
			PreparedStatement sqlStatement =(PreparedStatement) conn.prepareStatement("UPDATE relevance SET rating = '" + rating + "'where doc_id = '" + doc_id + "'");
			sqlStatement.executeUpdate();
		}catch (Exception e){
			System.out.println(e.getMessage());
		}
		finally {
			System.out.println("Updated successfully.");
		}
	}
	
	
	public static ArrayList<String> get() throws Exception{
		ArrayList<String> result = new ArrayList<String>();
		try{
			Connection conn = getConnection();
			PreparedStatement sqlStatement = (PreparedStatement) conn.prepareStatement("SELECT * FROM relevance");
			ResultSet res = sqlStatement.executeQuery();
			System.out.println("_____Retrieving data______");
			while(res.next()){
				System.out.println(res.getString(1) + " : " + res.getString(2));				
			}
			System.out.println("Successfully retrieved data !!");
		}catch(Exception ex){
			System.out.println(ex.getMessage());
		}
		
		return result;
	}
	//Inserting data to SQL
	public static void postData(String doc_id, String rating) throws Exception{
		try{
			Connection conn = getConnection();
			PreparedStatement sqlStatement = (PreparedStatement) conn.prepareStatement("INSERT INTO relevance (doc_id, rating) VALUES ('"+ doc_id +"','"+ rating+"')");
			sqlStatement.executeUpdate(); //Update is to manipulate data in database
		}
		catch (Exception e){
			System.out.println(e.getMessage());
		}
		finally {
			System.out.println("Insereted successfully.");
		}
	}
	
	//Getting JDBC Connection
	public static Connection getConnection() throws Exception{
		Connection conn = null;
		try{
			String driver = "com.mysql.jdbc.Driver";
			String url = "jdbc:mysql://localhost:3306/first_database";
			String username = "root";
			String password = " ";
			Class.forName(driver);
			conn = DriverManager.getConnection(url,username,password);
			System.out.println("Successfully Connected");
		}catch (Exception e){
			System.out.println(e.getMessage());
		}
		return conn;
	}
}
