build:
	pip-compile requirements.in --resolver=backtracking
	pip-sync requirements.txt

pip-init:
	pip install --no-cache-dir --upgrade pip
	pip3 install --no-cache-dir pip-tools

venv:
	python -m venv venv

test:
	pytest -v
