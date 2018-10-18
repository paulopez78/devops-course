# https://realpython.com/python-virtual-environments-a-primer/
python -m venv env
source env/bin/activate || source env/Scripts/activate
python -m pip install --upgrade pip
pip install -r requirements.txt > /dev/null

python main.py