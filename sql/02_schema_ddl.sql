-- ====================================================================
-- STUDENT EVENT MANAGEMENT SCHEMA (DDL)
-- Tables: EVENTS, STUDENTS, REGISTRATIONS, EVENT_AUDIT_LOGS
-- Sequences: SEQ_EVENT_ID, SEQ_STUDENT_ID, SEQ_REGISTRATION_ID, SEQ_AUDIT_LOG_ID
-- ====================================================================

-- Drop old objects cleanly if they exist
BEGIN
  EXECUTE IMMEDIATE 'DROP TABLE event_audit_logs CASCADE CONSTRAINTS';
EXCEPTION WHEN OTHERS THEN NULL;
END;
/
BEGIN
  EXECUTE IMMEDIATE 'DROP TABLE registrations CASCADE CONSTRAINTS';
EXCEPTION WHEN OTHERS THEN NULL;
END;
/
BEGIN
  EXECUTE IMMEDIATE 'DROP TABLE students CASCADE CONSTRAINTS';
EXCEPTION WHEN OTHERS THEN NULL;
END;
/
BEGIN
  EXECUTE IMMEDIATE 'DROP TABLE events CASCADE CONSTRAINTS';
EXCEPTION WHEN OTHERS THEN NULL;
END;
/
BEGIN
  EXECUTE IMMEDIATE 'DROP SEQUENCE seq_event_id';
EXCEPTION WHEN OTHERS THEN NULL;
END;
/
BEGIN
  EXECUTE IMMEDIATE 'DROP SEQUENCE seq_student_id';
EXCEPTION WHEN OTHERS THEN NULL;
END;
/
BEGIN
  EXECUTE IMMEDIATE 'DROP SEQUENCE seq_registration_id';
EXCEPTION WHEN OTHERS THEN NULL;
END;
/
BEGIN
  EXECUTE IMMEDIATE 'DROP SEQUENCE seq_audit_log_id';
EXCEPTION WHEN OTHERS THEN NULL;
END;
/

-- 1. SEQUENCES
CREATE SEQUENCE seq_event_id START WITH 101 INCREMENT BY 1 NOCACHE;
CREATE SEQUENCE seq_student_id START WITH 201 INCREMENT BY 1 NOCACHE;
CREATE SEQUENCE seq_registration_id START WITH 501 INCREMENT BY 1 NOCACHE;
CREATE SEQUENCE seq_audit_log_id START WITH 1 INCREMENT BY 1 NOCACHE;

-- 2. EVENTS TABLE
CREATE TABLE events (
    event_id              NUMBER(6) PRIMARY KEY,
    title                 VARCHAR2(100) NOT NULL,
    category              VARCHAR2(40) NOT NULL CHECK (category IN ('Hackathon', 'Workshop', 'Seminar', 'Cultural', 'Sports', 'Career Fair')),
    event_date            DATE NOT NULL,
    max_capacity          NUMBER(4) NOT NULL CHECK (max_capacity > 0),
    current_registrations NUMBER(4) DEFAULT 0 CHECK (current_registrations >= 0),
    registration_fee      NUMBER(8,2) DEFAULT 0.00 CHECK (registration_fee >= 0),
    venue                 VARCHAR2(80) NOT NULL
);

-- 3. STUDENTS TABLE
CREATE TABLE students (
    student_id            NUMBER(6) PRIMARY KEY,
    full_name             VARCHAR2(80) NOT NULL,
    email                 VARCHAR2(100) NOT NULL UNIQUE,
    major                 VARCHAR2(50) NOT NULL,
    year_of_study         NUMBER(1) CHECK (year_of_study BETWEEN 1 AND 5),
    phone                 VARCHAR2(20) NOT NULL
);

-- 4. REGISTRATIONS TABLE
CREATE TABLE registrations (
    registration_id       NUMBER(8) PRIMARY KEY,
    student_id            NUMBER(6) NOT NULL REFERENCES students(student_id) ON DELETE CASCADE,
    event_id              NUMBER(6) NOT NULL REFERENCES events(event_id) ON DELETE CASCADE,
    registration_date     TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    status                VARCHAR2(20) DEFAULT 'CONFIRMED' CHECK (status IN ('CONFIRMED', 'WAITLISTED', 'CANCELLED')),
    fee_paid              NUMBER(8,2) DEFAULT 0.00 CHECK (fee_paid >= 0),
    ticket_code           VARCHAR2(30) UNIQUE NOT NULL,
    CONSTRAINT uq_student_event UNIQUE (student_id, event_id)
);

-- 5. AUDIT LOGS TABLE (Populated by PL/SQL Triggers)
CREATE TABLE event_audit_logs (
    log_id                NUMBER(8) PRIMARY KEY,
    table_name            VARCHAR2(30) NOT NULL,
    action                VARCHAR2(15) NOT NULL,
    record_id             NUMBER(8) NOT NULL,
    details               VARCHAR2(250) NOT NULL,
    logged_by             VARCHAR2(50) DEFAULT USER,
    log_timestamp         TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
