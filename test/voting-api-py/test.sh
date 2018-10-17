# https://realpython.com/python-virtual-environments-a-primer/
python3 -m venv env
source env/bin/activate
pip install -r requirements.txt > /dev/null

python main.py