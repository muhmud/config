#!/usr/bin/python

from hackernews import HackerNews
hn = HackerNews()

top = hn.top_stories(limit=30)
print("{ \"top\": [")
for top_story in top:
    print("{ \"id\": \"%s\", \"url\": \"%s\", \"title\": \"%s\", \"score\": \"%s\" }," % (top_story.item_id, top_story.url, top_story.title, top_story.score))
print("{ } ] }")
