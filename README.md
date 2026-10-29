# Student Event Management System (Java JDBC & Oracle Free PL/SQL)

A clean, production-grade **Student Event Management System** built with **Java JDBC** and **Oracle Database 23c / 23ai Free** (or Oracle XE).

Pre-configured to run directly in **Visual Studio Code** in under 3 minutes!

---

## 🚀 3-Minute Quickstart in VS Code

### 1. Open in Visual Studio Code
- Extract this project into a folder.
- Open VS Code: `File -> Open Folder` -> Select the project root.
- Ensure the **Extension Pack for Java** is installed (VS Code will prompt you if missing).
- Install a **JDK 25 (LTS)** and Apache Maven 3.9+; the project compiles with the Java 25 API and bytecode level.

### 2. Start Oracle Database Free
Choose either **Docker (Recommended)** or **Local Oracle**:

#### With Docker (Instant):
Run in your VS Code terminal:
```bash
docker compose up -d
```
*(Starts Oracle 23c Free on port `1521` with password `StudentPass123#`)*

### 3. Initialize Database Schema & PL/SQL
In VS Code, run the SQL scripts in `sql/` in order using SQL*Plus, SQLcl, or the **Oracle Developer Tools for VS Code** extension:
1. `sql/01_oracle_free_setup.sql` (Creates user `student_admin` & grants rights)
2. `sql/02_schema_ddl.sql` (Creates `EVENTS`, `STUDENTS`, `REGISTRATIONS`, `EVENT_AUDIT_LOGS`)
3. `sql/03_plsql_procedures_functions.sql` (Creates `SP_REGISTER_STUDENT_EVENT`, `FN_CALCULATE_EVENT_REVENUE`, `SP_CANCEL_REGISTRATION`)
4. `sql/04_triggers.sql` (Creates `TRG_REGISTRATION_AUDIT`, `TRG_EVENT_CAPACITY_GUARD`)
5. `sql/05_seed_data.sql` (Populates sample events, students, registrations)

### 4. Run the Java Application
- Open `src/main/java/com/studentevents/Main.java` in VS Code.
- Press **F5** or click the **Run** button at the top-right.
- The interactive command-line interface will start right in your VS Code terminal!

---

## 🧩 Key Java JDBC & PL/SQL Concepts Demonstrated

1. **JDBC PreparedStatement**:
   - Parameterized queries to prevent SQL injection for listing, adding, and filtering events and students.
2. **JDBC CallableStatement with PL/SQL Stored Procedure**:
   - Calling `SP_REGISTER_STUDENT_EVENT` with 3 IN parameters and 3 OUT parameters (returns generated registration ID, unique ticket code, and status message).
3. **JDBC CallableStatement with PL/SQL Stored Function**:
   - Calling `FN_CALCULATE_EVENT_REVENUE(?)` returning a scalar numeric value.
4. **Oracle Row-Level Trigger**:
   - `TRG_REGISTRATION_AUDIT` automatically records ticket generation and cancellations in `EVENT_AUDIT_LOGS` on every INSERT or UPDATE.
5. **Capacity Guard & Automatic Waitlist**:
   - When an event hits maximum capacity, the PL/SQL procedure automatically marks registrations as `WAITLISTED`.
   - When a confirmed student cancels, the procedure automatically promotes the earliest waitlisted student!
