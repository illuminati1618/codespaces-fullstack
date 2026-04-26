#!/bin/bash
set -e

echo "=== Initializing submodules ==="
git -c submodule.recurse=false submodule update --init --depth 1 flask pages spring

echo "=== Installing shared system tools ==="
sudo apt-get update
sudo apt-get install -y python3-pip python-is-python3 python3-venv build-essential zlib1g-dev sqlite3 lsof

echo "=== Checking Java for Spring ==="
java -version
./spring/mvnw -v || true

echo "=== Setting up Pages ==="
cd pages
python -m venv venv
source venv/bin/activate
pip install -r requirements.txt
deactivate
bundle install || true

echo "=== Setting up Flask ==="
cd ../flask
python -m venv venv
source venv/bin/activate
pip install -r requirements.txt
deactivate

echo "=== Preparing Spring ==="
cd ../spring
./mvnw clean compile

echo "=== Setup complete ==="
echo "Run Pages:"
echo "  cd pages && source venv/bin/activate && make serve"
echo "Run Flask:"
echo "  cd flask && source venv/bin/activate && python main.py"
echo "Run Spring:"
echo "  cd spring && ./mvnw spring-boot:run"
