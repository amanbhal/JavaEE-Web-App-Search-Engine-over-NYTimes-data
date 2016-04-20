package com.irwebapp.pkg;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;

import org.json.*;
import java.util.*;

public class ProcessSearchResult {
	String search;
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
	
	public  static HashMap<String, Object> getContenForTimeTimeLine(String content){
		HashMap<String, Object> result = new HashMap<String, Object>();
		try{
			JSONObject jo = new JSONObject(content);
			result.put("time", jo.getJSONObject("responseHeader").get("QTime").toString());
			JSONArray arr = jo.getJSONObject("response").getJSONArray("docs");
			Map<String, List<String>> year_docidMap = new TreeMap<String, List<String>>(Collections.reverseOrder());
			for (int i = 0; i < arr.length(); i++) {
				String year = arr.getJSONObject(i).getJSONArray("date").getString(0).substring(0, 4);
				String docid = arr.getJSONObject(i).getJSONArray("lead_paragraph").getString(0);
				// System.out.println("Year :" + year + " Doc ID :" + docid);
				List<String> list = null;
				if (year_docidMap.containsKey(year)) {
					list = year_docidMap.get(year);
				} else {
					list = new ArrayList<String>();
				}
				list.add(docid);
				year_docidMap.put(year, list);
			}
			
			result.put("year_docidMap", year_docidMap);
			result.put("numOfResponse", jo.getJSONObject("response").get("numFound").toString());
		}catch(Exception ex){
			ex.printStackTrace();
		}
		return result;
	}

}
