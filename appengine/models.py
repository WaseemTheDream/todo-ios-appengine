
from google.appengine.ext import ndb


class Todo(ndb.Model):
    title = ndb.StringProperty()
    done = ndb.BooleanProperty()