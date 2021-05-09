

import requests
from flask import Flask, request, render_template, jsonify

app = Flask(__name__)


@app.route('/')
def home_page():
	return render_template('home.html')

@app.route('/', methods=['POST'])
def country_info():
	country = request.form['c']


	response = requests.get("https://restcountries.eu/rest/v2/name/"+country+"?fields=name;capital;languages;currencies")
	if response.status_code != 200:
		return "Country not found!"

		
	r = response.json()
	info = r[0]
	curr = info["currencies"][0]["code"]
	response2 = requests.get("http://data.fixer.io/api/latest?access_key=0f74f9e3e64cb0c2ce6ec5230dc7592d&format=1&symbols="+curr)
	r2 = response2.json()
	

	return jsonify("Name:", info["name"], "Capital:",info["capital"], "Language:", info["languages"][0]["name"],"Currency:", info["currencies"][0]["name"], "Currency Rate:", r2["rates"][curr])
	
app.run(host='0.0.0.0', debug=True)