from nytimesarticle import articleAPI
import os.path
import json

class Helper:
    def __init__(self):
        self.no_of_files = 0
        self.temp = 0

    keys = ['type_of_material', 'snippet', 'news_desk', 'lead_paragraph', 'source', 'pub_date']

    def get_articles(self, date, news_desk, key):
        api = articleAPI(key)
        start_months = ["0101", "0201", "0301", "0401", "0501", "0601", "0701", "0801", "0901", "1001", "1101", "1201"]
        end_months = ["0131", "0228", "0330", "0430", "0530", "0630", "0731", "0831", "0930", "1030", "1130", "1231"]
        for j in range(len(start_months)):
            for i in range(0, 200):
                try:
                    articles = api.search(fq={'source': ['The New York Times']}, begin_date=date + start_months[j],
                                          end_date=date + end_months[j], sort='oldest', page=str(i),
                                          news_desk=news_desk)
                    self.write_to_file(articles)
                    if self.temp > 20:
                        break
                except Exception, e:
                    print 'Error while extracting from API: ' + str(e)
                    continue

    def write_to_file(self, articles):
        parsedArticles = self.parse_articles(articles)
        for article in parsedArticles:
            file_path = "../json_data/" + article['headline'].replace("/","") + ".json"
            self.temp += 1
            if not os.path.isfile(file_path):
                if article['lead_paragraph']:
                    try:
                        json_data = json.dumps(article)
                        file_object = open(file_path, 'w')
                        file_object.write(json_data)
                        self.no_of_files += 1
                        self.temp = 0
                        print "No. of files downloaded:", self.no_of_files
                    except Exception, e:
                        print 'Error while writing to file: ' + str(e)
                        continue
                    finally:
                        file_object.close()



    def parse_articles(self, articles):
        '''
        This function takes in a response to the NYT api and parses
        the articles into a list of dictionaries
        '''
        news = []
        for i in articles['response']['docs']:
            try:
            # print i
                dic = {}
                dic['id'] = i['_id']
                if i['abstract'] is not None:
                    dic['abstract'] = i['abstract'].encode("utf8")
                dic['headline'] = i['headline']['main'].encode("utf8")
                dic['desk'] = i['news_desk']
                dic['date'] = i['pub_date'][0:10] # cutting time of day.
                dic['lead_paragraph'] = i['lead_paragraph']
                # locations
                locations = []
                try:
                    for x in range(0,len(i['keywords'])):
                        if 'glocations' in i['keywords'][x]['name']:
                            locations.append(i['keywords'][x]['value'])
                    dic['locations'] = locations
                    dic['author'] = i['byline']['original']
                except:
                    todoNothin = 0
                news.append(dic)
            except Exception, e:
                print e.message

        return news
