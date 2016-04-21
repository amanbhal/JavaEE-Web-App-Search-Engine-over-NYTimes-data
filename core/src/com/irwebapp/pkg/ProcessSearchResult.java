package com.irwebapp.pkg;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.TreeMap;

import org.json.JSONArray;
import org.json.JSONObject;

import com.resource.Document;

public class ProcessSearchResult {

	private String search;
	private final String USER_AGENT = "Mozilla/5.0 (Windows NT 5.1; rv:19.0) Gecko/20100101 Firefox/19.0";

	public ProcessSearchResult(String search) {
		this.search = search;
	}

	public String getContent() {
		String content = "";
		try {
			this.search = this.search.replaceAll(" ", "%20");
			String url = "http://10.202.156.150:8983/solr/gettingstarted_shard1_replica1/select?q="
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
			for (int i = 0; i < arrayOfDocsAsJSON.length(); i++) {

				JSONObject JSONObjectForDoc = arrayOfDocsAsJSON
						.getJSONObject(i);

				String year = JSONObjectForDoc.getJSONArray("date")
						.getString(0).substring(0, 4);

				double ratingForDoc = getRatingForDoc((String) JSONObjectForDoc
						.get("id"));

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

	public static double getRatingForDoc(String docID) {
		return 1.0;
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
