
pkill gunicorn
kill -9 $(lsof -t -i :9000)
gunicorn --workers 4 --bind 0.0.0.0:9000 wsgi:application
#gunicorn --reload --bind 127.0.0.1:9000 wsgi:application

