const mysql = require("mysql2");

const pool = mysql.createPool({
  connectionLimit: 10,
  host: process.env.MYSQLHOST || DB_HOST,
  user: process.env.MYSQLUSER || DB_USER,
  password: process.env.MYSQLPASSWORD || DB_PASSWORD,
  database: process.env.MYSQLDATABASE || CDB_NAME,
  port: process.env.MYSQLPORT || 3306,
});

module.exports = pool;
