#!/bin/bash
sed -i 's/host: 127.0.0.1:3306/host: '$MYSQL_HOST':'$MYSQL_PORT'/g' /etc/jackal/jackal.yml
sed -i 's/user: jackal/user: '$MYSQL_USER'/g' /etc/jackal/jackal.yml
sed -i 's/password: somepass/password: '$MYSQL_PASS'/g' /etc/jackal/jackal.yml
sed -i 's/database: jackal/database: '$MYSQL_DB'/g' /etc/jackal/jackal.yml
