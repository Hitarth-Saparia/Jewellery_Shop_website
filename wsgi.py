#!/usr/bin/env python3
"""
Root WSGI entry point for Gunicorn / uWSGI servers.
"""
from app import app, application

if __name__ == '__main__':
    app.run()
