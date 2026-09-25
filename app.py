#!/usr/bin/env python3
"""
Root WSGI application entry point for cloud deployment (Render, Railway, Heroku).
Exports the Flask 'app' instance for Gunicorn and WSGI servers.
"""
import os
import sys

# Ensure backend directory is in Python path
base_dir = os.path.dirname(os.path.abspath(__file__))
backend_dir = os.path.join(base_dir, 'backend')
if backend_dir not in sys.path:
    sys.path.insert(0, backend_dir)

# Import Flask app and Config directly from backend.app package
from backend.app import app, Config

# Alias for WSGI servers expecting 'application'
application = app

if __name__ == '__main__':
    port = int(os.environ.get('PORT', Config.PORT))
    app.run(host='0.0.0.0', port=port)
