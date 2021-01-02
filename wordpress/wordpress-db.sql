DROP USER 'wordpress-user'@'localhost';
CREATE USER 'wordpress-user'@'localhost' IDENTIFIED BY 'your_strong_password';
CREATE DATABASE IF NOT EXISTS `wordpress-db`;
GRANT ALL PRIVILEGES ON `wordpress-db`.* TO "wordpress-user"@"localhost";
FLUSH PRIVILEGES;
exit
