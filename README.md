# Student Event Management System

A console application built with **Java JDBC** and **Oracle PL/SQL**. Students register for campus events. When an event is full, new registrations go on a waitlist, and the earliest waitlisted student is promoted automatically when someone cancels.

Tested on **Oracle Database 11g Express Edition (XE)** with **JDK 23** in Visual Studio Code.

## Features

- Add and list students and events (JDBC `PreparedStatement`)
- Register a student through a stored procedure with 3 IN and 3 OUT parameters (`CallableStatement`)
- Calculate event revenue through a stored function
- Cancel a registration with a refund, and promote the next waitlisted student
- Automatic audit log written by an Oracle row-level trigger
- Capacity guard trigger that blocks lowering capacity below confirmed registrations

## Project structure

```
sql/                      Database scripts, run in order 01 to 05
src/main/java/com/studentevents/
    Main.java             Console menu
    DatabaseConnection.java   Opens the JDBC connection
    dao/                  JDBC code (EventDAO, StudentDAO, RegistrationDAO)
    model/                Plain Java classes
src/main/resources/db.properties   Connection settings
pom.xml                   Maven build and Oracle JDBC driver
```

## Setup

### 1. Requirements

- Oracle Database XE 11g (or newer) running locally on port 1521
- JDK 17 or newer
- Visual Studio Code with the **Extension Pack for Java**

### 2. Create the user and tables

From the project folder, open SQL*Plus as an administrator:

```
sqlplus / as sysdba
```

Then run the scripts in order:

```
@sql/01_oracle_free_setup.sql
```

This creates the user `student_admin` (password `StudentPass123#`). Then connect as that user and run the rest:

```
CONNECT student_admin/"StudentPass123#"@localhost:1521/XE
SET DEFINE OFF
@sql/02_schema_ddl.sql
@sql/03_plsql_procedures_functions.sql
@sql/04_triggers.sql
@sql/05_seed_data.sql
```

Each script should print "created" messages and no compilation errors.

### 3. Check the connection settings

`src/main/resources/db.properties`:

```
db.url=jdbc:oracle:thin:@localhost:1521/XE
db.user=student_admin
db.password=StudentPass123#
```

The URL has four parts: the driver (`jdbc:oracle:thin`), the host (`localhost`), the listener port (`1521`) and the service name (`XE`).

### 4. Run the application

Open `src/main/java/com/studentevents/Main.java` in VS Code and use the Java extension's **Run** button. A menu appears in the terminal. The first line printed should be `SUCCESS: Connected to Oracle Database successfully!`.

## Other Oracle versions

- **Oracle Database 23ai Free (or XE 21c):** use the service name `FREEPDB1` (or `XEPDB1` for XE 21c) in `db.properties`, and add `ALTER SESSION SET CONTAINER = FREEPDB1;` at the top of `sql/01_oracle_free_setup.sql`.
- **Docker:** `docker compose up -d` starts Oracle 23ai Free on port 1521 with password `StudentPass123#`. Use the `FREEPDB1` settings above.

## Database objects

| Type | Name | Purpose |
|---|---|---|
| Tables | `EVENTS`, `STUDENTS`, `REGISTRATIONS`, `EVENT_AUDIT_LOGS` | Core data |
| Sequences | `SEQ_EVENT_ID`, `SEQ_STUDENT_ID`, `SEQ_REGISTRATION_ID`, `SEQ_AUDIT_LOG_ID` | Generated IDs |
| Procedure | `SP_REGISTER_STUDENT_EVENT` | Confirms or waitlists a registration |
| Procedure | `SP_CANCEL_REGISTRATION` | Cancels, refunds and promotes the waitlist |
| Function | `FN_CALCULATE_EVENT_REVENUE` | Total fees from confirmed registrations |
| Trigger | `TRG_REGISTRATION_AUDIT` | Logs every registration and status change |
| Trigger | `TRG_EVENT_CAPACITY_GUARD` | Protects event capacity |
