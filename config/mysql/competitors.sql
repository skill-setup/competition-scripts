CREATE DATABASE IF NOT EXISTS `competitor-1`;
CREATE DATABASE IF NOT EXISTS `competitor-2`;
CREATE DATABASE IF NOT EXISTS `competitor-3`;
CREATE DATABASE IF NOT EXISTS `competitor-4`;
CREATE DATABASE IF NOT EXISTS `competitor-5`;
CREATE DATABASE IF NOT EXISTS `competitor-6`;
CREATE DATABASE IF NOT EXISTS `competitor-7`;
CREATE DATABASE IF NOT EXISTS `competitor-8`;
CREATE DATABASE IF NOT EXISTS `competitor-9`;

CREATE USER IF NOT EXISTS `competitor-1`@'%' IDENTIFIED BY '4621';
CREATE USER IF NOT EXISTS `competitor-2`@'%' IDENTIFIED BY '7552';
CREATE USER IF NOT EXISTS `competitor-3`@'%' IDENTIFIED BY '6513';
CREATE USER IF NOT EXISTS `competitor-4`@'%' IDENTIFIED BY '2494';
CREATE USER IF NOT EXISTS `competitor-5`@'%' IDENTIFIED BY '6455';
CREATE USER IF NOT EXISTS `competitor-6`@'%' IDENTIFIED BY '9546';
CREATE USER IF NOT EXISTS `competitor-7`@'%' IDENTIFIED BY '9999';
CREATE USER IF NOT EXISTS `competitor-8`@'%' IDENTIFIED BY '6825';
CREATE USER IF NOT EXISTS `competitor-9`@'%' IDENTIFIED BY '9863';

GRANT ALL PRIVILEGES ON `competitor-1`.* TO 'competitor-1'@'%';
GRANT ALL PRIVILEGES ON `competitor-2`.* TO 'competitor-2'@'%';
GRANT ALL PRIVILEGES ON `competitor-3`.* TO 'competitor-3'@'%';
GRANT ALL PRIVILEGES ON `competitor-4`.* TO 'competitor-4'@'%';
GRANT ALL PRIVILEGES ON `competitor-5`.* TO 'competitor-5'@'%';
GRANT ALL PRIVILEGES ON `competitor-6`.* TO 'competitor-6'@'%';
GRANT ALL PRIVILEGES ON `competitor-7`.* TO 'competitor-7'@'%';
GRANT ALL PRIVILEGES ON `competitor-8`.* TO 'competitor-7'@'%';
GRANT ALL PRIVILEGES ON `competitor-9`.* TO 'competitor-7'@'%';