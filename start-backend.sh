#!/bin/bash

# Start the Perl backend server
echo "Starting Perl backend server on port 3000..."
echo "Backend will be available at http://localhost:3000"
echo "Press Ctrl+C to stop the server"
echo ""

./backend.pl daemon -l http://*:3000

