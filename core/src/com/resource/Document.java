package com.resource;

import org.json.JSONObject;

public class Document {

	private JSONObject docAsJSON;
	private double docRating;

	public Document(JSONObject docAsJSON, double docRating) {

		this.docAsJSON = docAsJSON;
		this.docRating = docRating;

	}

	public JSONObject getDocAsJSON() {
		return docAsJSON;
	}

	public void setDocAsJSON(JSONObject docAsJSON) {
		this.docAsJSON = docAsJSON;
	}

	public double getDocRating() {
		return docRating;
	}

	public void setDocRating(double docRating) {
		this.docRating = docRating;
	}

}
