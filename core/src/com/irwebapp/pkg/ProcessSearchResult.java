package com.irwebapp.pkg;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.sql.Connection;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.TreeMap;

import org.json.JSONArray;
import org.json.JSONObject;

import com.database.database;
import com.resource.Document;

public class ProcessSearchResult {

	private String search;
	private final String USER_AGENT = "Mozilla/5.0 (Windows NT 5.1; rv:19.0) Gecko/20100101 Firefox/19.0";
	static Connection conn;
	public ProcessSearchResult(String search) {
		this.search = search;
		try {
			conn =  database.getConnection();
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

	public String getContent() {
		String content = "";
		try {
			this.search = this.search.replaceAll(" ", "%20");
			String url = "http://10.202.157.33:8983/solr/gettingstarted_shard1_replica1/select?q="
					+ this.search + "&rows=10000000&wt=json&indent=true";
			URL obj = new URL(url);
			HttpURLConnection con = (HttpURLConnection) obj.openConnection();
			con.setRequestMethod("GET");
			con.setRequestProperty("User-Agent", USER_AGENT);

			int responseCode = con.getResponseCode();
			System.out.println("\nSending 'GET' request to URL : " + url);
			System.out.println("Response Code : " + responseCode);

			BufferedReader in = new BufferedReader(new InputStreamReader(
					con.getInputStream()));
			String inputLine;
			StringBuffer response = new StringBuffer();

			while ((inputLine = in.readLine()) != null) {
				response.append(inputLine);
			}
			in.close();
			content = response.toString();
		} catch (Exception e) {
			System.out.println("Error while getting content for the query");
			e.printStackTrace();
		}

		return content;

	}

	public static HashMap<String, Object> getContenForTimeTimeLine(
			String content) {
		HashMap<String, Object> result = new HashMap<String, Object>();
		try {

			JSONObject jsonObject = new JSONObject(content);
			result.put("respones_time_in_millisecond", jsonObject
					.getJSONObject("responseHeader").get("QTime").toString());
			JSONArray arrayOfDocsAsJSON = jsonObject.getJSONObject("response")
					.getJSONArray("docs");
			Map<String, List<Document>> year_docMap = new TreeMap<String, List<Document>>(
					Collections.reverseOrder());
			//Database changes
			double meanRatingOfSystem = database.getAverageRating(conn);
			double totalHits = database.getTotalHits(conn);
			ArrayList<String> doc_ids = new ArrayList<String>();
			for (int i = 0; i < arrayOfDocsAsJSON.length(); i++) {
				JSONObject JSONObjectForDoc = arrayOfDocsAsJSON
						.getJSONObject(i);
				String doc_id = (String) JSONObjectForDoc.get("id");
				doc_ids.add(doc_id);
			}
			
			HashMap<String,HashMap<String, Integer>> ratingsForAllDocs = database.getRatingsForAllDocuments(conn, doc_ids);
			for (int i = 0; i < arrayOfDocsAsJSON.length(); i++) {

				JSONObject JSONObjectForDoc = arrayOfDocsAsJSON
						.getJSONObject(i);

				String year = JSONObjectForDoc.getJSONArray("date")
						.getString(0).substring(0, 4);
				String doc_id = (String) JSONObjectForDoc.get("id");
				double ratingForDoc = getRatingForDoc(ratingsForAllDocs.get(doc_id), meanRatingOfSystem, totalHits);

				Document newDoc = new Document(JSONObjectForDoc, ratingForDoc);

				List<Document> doc_list = null;
				if (year_docMap.containsKey(year)) {
					doc_list = year_docMap.get(year);
				} else {
					doc_list = new ArrayList<Document>();
				}
				doc_list.add(newDoc);
				year_docMap.put(year, doc_list);
			}

			for (String year : year_docMap.keySet()) {
				List<Document> eachDocList = year_docMap.get(year);
				Collections.sort(eachDocList, new MyComparator());
			}
			result.put("year_docMap", year_docMap);
			result.put("numOfResponse", jsonObject.getJSONObject("response")
					.get("numFound").toString());
		} catch (Exception ex) {
			System.out
					.println("Error while getting the content from the server.");
			ex.printStackTrace();
		}
		return result;
	}
	public static void updateDocumentRating(String doc_id, int rating){
		String rating_name = "three_star";
		switch (rating) {
		case 5:
			rating_name = "five_star";
			break;
		case 4:
			rating_name = "four_star";
			break;
		case 2:
			rating_name = "two_star";
			break;
		case 1:
			rating_name = "one_star";
			break;

		default:
			rating_name = "three_star";
			break;
		}
		
		try {
			database.updateGlobalRatings(conn, rating);
			database.updateDocumentRatings(conn, doc_id, rating_name);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
	
	public static void updateDocumentHits(String doc_id){
		try {
			database.updateDocumentRatings(conn, doc_id, "hits");
			database.updateTotalHits(conn);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
	
	public static HashMap<String,Integer> getDocumentRating(String doc_id){
		HashMap<String,Integer> result = new HashMap<String,Integer>();
		try {
			result = database.getDocumentRatings(conn, doc_id);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return result;
	}
	
	public static double getRatingForDoc(HashMap<String, Integer> ratingsForDocument, double meanRatingOfSystem, double totalHits) {
		double totalRatingCurrentDocument = 0.0;
		try {
			double noOfVotes = (double)getNumberOfVotes(ratingsForDocument);
			double minimumVotesRequired = 10.0;
			double meanRating = getMeanRating(ratingsForDocument, noOfVotes);
			
			
			double weightedRating  = (noOfVotes/ (noOfVotes + minimumVotesRequired)) * meanRating;		//Formula from IMDb
			weightedRating += (meanRating/ (noOfVotes + minimumVotesRequired)) * meanRatingOfSystem;
			int hitsForCurrentDocument = ratingsForDocument.get("hits");
			double weightForBaysianAverage =  (double)hitsForCurrentDocument/totalHits;					//Using Bayesian average
			double ratingsBasedOnHits = weightForBaysianAverage * meanRating + (1 - weightForBaysianAverage) * meanRatingOfSystem;
			
			totalRatingCurrentDocument = weightedRating + ratingsBasedOnHits;
			
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return totalRatingCurrentDocument;
	}
	
	
	public static int getNumberOfVotes(HashMap<String, Integer> ratingsForDocument){
		int result = 0;
		try{
			result += ratingsForDocument.get("five_star");
			result += ratingsForDocument.get("four_star");
			result += ratingsForDocument.get("three_star");
			result += ratingsForDocument.get("two_star");
			result += ratingsForDocument.get("one_star");
		}catch(Exception ex){
			ex.printStackTrace();
		}
		return result;
	}
	
	
	public static double getMeanRating(HashMap<String, Integer> ratingsForDocument, double noOfVotes){
		if(noOfVotes < 1)
			return 0.0;
		int totalRating = 0;
		try{
			totalRating += ratingsForDocument.get("five_star") * 5;
			totalRating += ratingsForDocument.get("four_star") * 4;
			totalRating += ratingsForDocument.get("three_star") * 3;
			totalRating += ratingsForDocument.get("two_star") * 2;
			totalRating += ratingsForDocument.get("one_star") * 1;
		}catch(Exception ex){
			ex.printStackTrace();
		}
		return (double)totalRating/(double)noOfVotes;
	}

	static class MyComparator implements Comparator<Document> {

		@Override
		public int compare(Document doc1, Document doc2) {
			if (doc2.getDocRating() > doc1.getDocRating()) {
				return 1;
			} else if (doc2.getDocRating() < doc1.getDocRating()) {
				return -1;
			} else {
				return 0;
			}
		}
	}

}
