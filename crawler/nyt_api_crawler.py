from api_query_helper import Helper

helper_instance = Helper()

category_file = open("desk_values.txt", 'r')
categories = category_file.read().split("\n")

key = 'sample-key'

for i in range(1991,1990 , -1):
    print 'Processing ' + str(i) + '...'
    for news_desk in categories:
        helper_instance.get_articles(str(i), news_desk, key)
