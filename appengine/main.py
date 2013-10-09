#!/usr/bin/env python
#
# Copyright 2007 Google Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
import webapp2
import json
import logging

from google.appengine.ext import ndb


class Todo(ndb.Model):
    title = ndb.StringProperty()
    done = ndb.BooleanProperty()

    def to_dict(self):
        return {
            'title': self.title,
            'done': self.done,
            'key': str(self.key.id())
        }

class TodoHandler(webapp2.RequestHandler):
    def get(self):
        todos = Todo.query().fetch()
        out = {
            'todos': [todo.to_dict() for todo in todos]
        }
        self.response.headers['Content-Type'] = 'application/json'
        self.response.write(json.dumps(out))

    def post(self):
        input = json.loads(self.request.body)
        logging.info(input)
        todo = Todo(
            title=input['title'],
            done=input['done']
        )
        todo.put()
        self.response.write(json.dumps(todo.to_dict()))

    def put(self):
        input = json.loads(self.request.body)
        logging.info(input)
        todo = Todo.get_by_id(int(input['key']))
        todo.title = input['title']
        todo.done = input['done']
        todo.put()
        self.response.write(json.dumps(todo.to_dict()))

    def delete(self):
        input = json.loads(self.request.body)
        logging.info(input)
        todo = Todo.get_by_id(int(input['key']))
        todo.key.delete()

class MainHandler(webapp2.RequestHandler):
    def get(self):
        self.response.write('Hello world!')

app = webapp2.WSGIApplication([
    ('/', MainHandler),
    ('/todo', TodoHandler)
], debug=True)
