-- ====================================================================
-- ORACLE PL/SQL TRIGGERS
-- 1. TRG_REGISTRATION_AUDIT: Row-level audit logging on REGISTRATIONS
-- 2. TRG_EVENT_CAPACITY_GUARD: Capacity integrity check on EVENTS
-- ====================================================================

-- 1. AUDIT TRIGGER: Automatically logs all registrations and status updates
CREATE OR REPLACE TRIGGER TRG_REGISTRATION_AUDIT
AFTER INSERT OR UPDATE ON registrations
FOR EACH ROW
DECLARE
    v_details VARCHAR2(250);
    v_action VARCHAR2(15);
BEGIN
    IF INSERTING THEN
        v_action := 'REGISTRATION';
        v_details := 'Ticket: ' || :NEW.ticket_code || ' for Student #' || :NEW.student_id || 
                     ' (Event #' || :NEW.event_id || '). Status: ' || :NEW.status || ', Fee: $' || :NEW.fee_paid;
    ELSIF UPDATING THEN
        IF :NEW.status = 'CANCELLED' AND :OLD.status != 'CANCELLED' THEN
            v_action := 'CANCELLATION';
            v_details := 'Registration #' || :NEW.registration_id || ' CANCELLED. Refunded: $' || :OLD.fee_paid;
        ELSE
            v_action := 'UPDATE';
            v_details := 'Status changed: ' || :OLD.status || ' -> ' || :NEW.status || ' (Ticket: ' || :NEW.ticket_code || ')';
        END IF;
    END IF;

    INSERT INTO event_audit_logs (
        log_id, table_name, action, record_id, details, logged_by, log_timestamp
    ) VALUES (
        seq_audit_log_id.NEXTVAL, 'REGISTRATIONS', v_action, :NEW.registration_id, v_details, 'TRG_REGISTRATION_AUDIT', SYSTIMESTAMP
    );
END TRG_REGISTRATION_AUDIT;
/

-- 2. CAPACITY GUARD TRIGGER: Prevents reducing max_capacity below existing confirmed registrations
CREATE OR REPLACE TRIGGER TRG_EVENT_CAPACITY_GUARD
BEFORE UPDATE OF max_capacity ON events
FOR EACH ROW
BEGIN
    IF :NEW.max_capacity < :OLD.current_registrations THEN
        RAISE_APPLICATION_ERROR(-20006, 'Cannot set max capacity (' || :NEW.max_capacity || 
                                ') below existing confirmed registrations (' || :OLD.current_registrations || ').');
    END IF;
END TRG_EVENT_CAPACITY_GUARD;
/
