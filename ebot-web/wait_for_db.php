<?php
$host = 'mysqldb';
$user = 'root';
$pass = getenv('MYSQL_ROOT_PASSWORD');
$db   = getenv('MYSQL_DATABASE');
$waitTimeoutInSeconds = 600;

$started = time();

echo "Waiting for MySQL to be ready";
do {
    $mysqli = @new mysqli($host, $user, $pass, $db);
    if ($mysqli->connect_errno) {
        if ((time() - $started) > $waitTimeoutInSeconds) {
            die("Unable to connect to MySQL after $waitTimeoutInSeconds seconds");
        }
        echo "Still not ready!";
        sleep(5);
    }
} while($mysqli->connect_errno);

echo "Connected to MySQL";
$mysqli->close();
?>
