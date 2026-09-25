#!/usr/bin/env python3
"""
Root entry point to launch the Vijayraj Gems and Jewellery Shop web application.
Delegates directly to backend/app.py.
"""
import os
import sys

base_dir = os.path.dirname(os.path.abspath(__file__))
backend_dir = os.path.join(base_dir, 'backend')
if backend_dir not in sys.path:
    sys.path.insert(0, backend_dir)

from app import app, Config

if __name__ == '__main__':
    print("=" * 60)
    print("💎 Vijayraj Gems & Jewellery Shop Management System 💍")
    print("=" * 60)
    print(f"Server URL:  http://{Config.HOST}:{Config.PORT}")
    print(f"Debug Mode:  {Config.DEBUG}")
    print(f"Frontend:    {os.path.join(base_dir, 'frontend')}")
    print(f"Backend:     {backend_dir}")
    print(f"Mode:        Pure Server-Side Jinja2 (Zero API Layer)")
    print("=" * 60)
    app.run(host=Config.HOST, port=Config.PORT, debug=Config.DEBUG)
