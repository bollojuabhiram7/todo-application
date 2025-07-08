#!/bin/bash

# Start the Angular frontend development server
echo "Starting Angular frontend development server on port 4200..."
echo "Frontend will be available at http://localhost:4200"
echo "Press Ctrl+C to stop the server"
echo ""

cd frontend
ng serve --host 0.0.0.0 --port 4200

