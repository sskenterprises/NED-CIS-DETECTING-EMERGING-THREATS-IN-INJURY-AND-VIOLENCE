from flask import Flask,jsonify,request,make_response
from werkzeug.serving import WSGIRequestHandler
import argparse
from urllib.parse import urlparse
import urllib
import csv
import tweepy
import pandas as pd
from textblob import TextBlob
import tweepy
import unidecode
import flask_excel as excel
import pyexcel as pe
from flask_cors import CORS


app = Flask(__name__)

CORS(app)

@app.route('/api', methods=['GET'])
def crawler():
    global qw, c

    qw = str(request.args['qw'])

    c = int(request.args['c'])

    main()

    twitter_data = pd.read_csv('results.csv')
    resp = make_response(twitter_data.to_csv())
    resp.headers["Content-Disposition"] = "attachment; filename=export.csv"
    resp.headers["Content-Type"] = "text/csv"
    return resp

def main():
    # global ge, l, t, d
    # print("Query: %s, Location: %s, Language: %s, Search type: %s, Count: %s" % (qw, ge, l, t, c))

    f = open('auth.k','r')
    ak = f.readlines()
    f.close()
    auth1 = tweepy.auth.OAuthHandler(ak[0].replace("\n",""), ak[1].replace("\n",""))
    auth1.set_access_token(ak[2].replace("\n",""), ak[3].replace("\n",""))
    api = tweepy.API(auth1)

    # Tweeter search with keyword
    target_num =c
    query = qw

    csvFile = open('results_drugs.csv', 'w', encoding="utf-8")
    csvWriter = csv.writer(csvFile)
    csvWriter.writerow(["username","user since","author id","author loc","created", "text", "retwc","place", "hashtag", "followers", "friends","polarity","subjectivity"])
    counter = 0

    for tweet in tweepy.Cursor(api.search, q = query, lang = "en", result_type = "popular", count = target_num).items():
        created = tweet.created_at
        text = tweet.text
        text = unidecode.unidecode(text)
        retwc = tweet.retweet_count
        try:
            hashtag = tweet.entities[u'hashtags'][0][u'text']  # hashtags used
        except:
            hashtag = "None"
        username = tweet.author.name  # author/user name
        usersince = tweet.author.created_at
        authorid = tweet.author.id  # author/user ID#
        authorloc = tweet.author.location
        place= tweet.place
        followers = tweet.author.followers_count  # number of author/user followers (inlink)
        friends = tweet.author.friends_count  # number of author/user friends (outlink)

        text_blob = TextBlob(text)
        polarity = text_blob.polarity
        subjectivity = text_blob.subjectivity
        csvWriter.writerow([username,usersince,authorid,authorloc, created, text, retwc,place, hashtag, followers, friends, polarity, subjectivity])

        counter = counter + 1
        if (counter == target_num):
            break

    csvFile.close()

if __name__ == "__main__":
    WSGIRequestHandler.protocol_version = "HTTP/1.1"
    # main()
    app.run()
