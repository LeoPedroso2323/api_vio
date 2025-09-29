const mysql = require("mysql2");

const pool = mysql.createPool({
  connectionLimit: 10,
  host: process.env.MYSQLHOST || DB_HOST,
  user: process.env.MYSQLHOST || DB_USER,
  password: process.env.MYSQLPASSWORD || DB_PASSWORD,
  database: process.env.MYSQLHOST || CDB_NAME,
  port: process.env.MYSQLPORT || 3306,
});

module.exports = pool;
