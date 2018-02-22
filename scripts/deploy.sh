set -x

ssh -i /home/marcin/.ssh/aws.pem alpine@"$1" rm -rf /home/alpine/reddit
ssh -i /home/marcin/.ssh/aws.pem alpine@"$1" mkdir /home/alpine/reddit/

scp -i /home/marcin/.ssh/aws.pem -r \
  ./app \
  ./bin \
  ./config \
  ./db \
  ./public \
  ./scripts \
  ./config.ru \
  ./Gemfile \
  ./Gemfile.lock \
  ./package.json \
  ./Rakefile \
  alpine@"$1":/home/alpine/reddit/

ssh -i /home/marcin/.ssh/aws.pem alpine@"$1" sudo chmod +x /home/alpine/reddit/scripts/*.ch

ssh -i /home/marcin/.ssh/aws.pem alpine@"$1" sudo /bin/sh -c "/home/alpine/reddit/scripts/env.sh"
ssh -i /home/marcin/.ssh/aws.pem alpine@"$1" sudo /bin/sh -c "/home/reddit/scripts/run.sh"
