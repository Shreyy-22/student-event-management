-- ====================================================================
-- ORACLE DATABASE 23c / 23ai FREE USER & PRIVILEGES SETUP
-- Run this as SYS or SYSTEM in Oracle SQL*Plus, SQLcl, or VS Code
-- ====================================================================

-- 1. Switch to pluggable database (PDB) in Oracle Free
-- (Oracle XE 11g has no pluggable databases, so no container switch is needed)

-- 2. Create the project user
CREATE USER student_admin IDENTIFIED BY "StudentPass123#"
  DEFAULT TABLESPACE users
  TEMPORARY TABLESPACE temp
  QUOTA UNLIMITED ON users;

-- 3. Grant necessary privileges for JDBC and PL/SQL development
GRANT CREATE SESSION TO student_admin;
GRANT CREATE TABLE TO student_admin;
GRANT CREATE SEQUENCE TO student_admin;
GRANT CREATE PROCEDURE TO student_admin;
GRANT CREATE TRIGGER TO student_admin;
GRANT CREATE VIEW TO student_admin;

-- 4. Verify connection
CONNECT student_admin/"StudentPass123#"@localhost:1521/XE;
SELECT sys_context('USERENV', 'CURRENT_USER') AS current_user FROM dual;
