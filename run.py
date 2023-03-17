'''
Author: 1dayluo
Date: 2023-03-17 23:40:15
LastEditTime: 2023-03-17 23:54:20
'''
from flask import Flask, render_template
import os
from watchdog.observers import Observer
from watchdog.events import FileSystemEventHandler

app = Flask(__name__)

@app.route("/")
def index():
    
    files = os.listdir("output")
    return render_template("index.html", files=files)

# Define a watchdog class for monitoring file changes
class FileChangeHandler(FileSystemEventHandler):
    def on_modified(self, event):
        # If any file in the output folder is modified, refresh the homepage
        if event.src_path.startswith("output"):
            with app.test_request_context():
                index()

# Create an observer object and start it before running the app
observer = Observer()
handler = FileChangeHandler()
observer.schedule(handler, path="output", recursive=True)
observer.start()

# Run the app in debug mode
if __name__ == "__main__":
    app.run(debug=True)