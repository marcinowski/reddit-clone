# This is for alpine distribution

sudo cd /home/alpine/reddit/
sudo rails db:migrate
sudo rails server -p 80 -b 0.0.0.0
