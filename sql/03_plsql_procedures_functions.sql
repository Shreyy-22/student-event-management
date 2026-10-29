-- ====================================================================
-- PL/SQL STORED PROCEDURES & FUNCTIONS FOR STUDENT EVENT MANAGEMENT
-- 1. SP_REGISTER_STUDENT_EVENT: Procedure with IN and 3 OUT parameters
-- 2. FN_CALCULATE_EVENT_REVENUE: Function returning total confirmed ticket fees
-- 3. SP_CANCEL_REGISTRATION: Procedure cancelling ticket & promoting waitlist
-- ====================================================================

SET SERVEROUTPUT ON;

-- 1. STORED PROCEDURE: Register a student for an event
CREATE OR REPLACE PROCEDURE SP_REGISTER_STUDENT_EVENT (
    p_student_id   IN  NUMBER,
    p_event_id     IN  NUMBER,
    p_fee_paid     IN  NUMBER,
    p_reg_id       OUT NUMBER,
    p_ticket_code  OUT VARCHAR2,
    p_status_msg   OUT VARCHAR2
) AS
    v_event_exists NUMBER;
    v_student_exists NUMBER;
    v_max_capacity NUMBER;
    v_current_regs NUMBER;
    v_reg_status VARCHAR2(20);
BEGIN
    -- Validate Student
    SELECT COUNT(*) INTO v_student_exists FROM students WHERE student_id = p_student_id;
    IF v_student_exists = 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Student ID ' || p_student_id || ' does not exist.');
    END IF;

    -- Validate Event & Get Capacity
    SELECT max_capacity, current_registrations
    INTO v_max_capacity, v_current_regs
    FROM events
    WHERE event_id = p_event_id;

    -- Check if already registered
    DECLARE
        v_already NUMBER;
    BEGIN
        SELECT COUNT(*) INTO v_already 
        FROM registrations 
        WHERE student_id = p_student_id AND event_id = p_event_id AND status != 'CANCELLED';
        IF v_already > 0 THEN
            RAISE_APPLICATION_ERROR(-20002, 'Student is already registered for this event.');
        END IF;
    END;

    -- Generate sequence ID
    p_reg_id := seq_registration_id.NEXTVAL;

    -- Determine status based on capacity
    IF v_current_regs < v_max_capacity THEN
        v_reg_status := 'CONFIRMED';
        p_ticket_code := 'TKT-EVT' || p_event_id || '-REG' || p_reg_id;
        p_status_msg := 'CONFIRMED: Seat reserved successfully!';

        -- Increment event confirmed registrations counter
        UPDATE events 
        SET current_registrations = current_registrations + 1 
        WHERE event_id = p_event_id;
    ELSE
        v_reg_status := 'WAITLISTED';
        p_ticket_code := 'WLIST-EVT' || p_event_id || '-REG' || p_reg_id;
        p_status_msg := 'WAITLISTED: Event is full. Placed on priority waitlist.';
    END IF;

    -- Insert registration record
    INSERT INTO registrations (
        registration_id, student_id, event_id, registration_date, status, fee_paid, ticket_code
    ) VALUES (
        p_reg_id, p_student_id, p_event_id, SYSTIMESTAMP, v_reg_status, p_fee_paid, p_ticket_code
    );

    DBMS_OUTPUT.PUT_LINE('[PL/SQL] ' || p_status_msg || ' Code: ' || p_ticket_code);
    COMMIT;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        ROLLBACK;
        RAISE_APPLICATION_ERROR(-20003, 'Event ID ' || p_event_id || ' does not exist.');
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('[PL/SQL Error] ' || SQLERRM);
        RAISE;
END SP_REGISTER_STUDENT_EVENT;
/

-- 2. STORED FUNCTION: Calculate Total Revenue for an Event
CREATE OR REPLACE FUNCTION FN_CALCULATE_EVENT_REVENUE (
    p_event_id IN NUMBER
) RETURN NUMBER AS
    v_total_revenue NUMBER := 0;
BEGIN
    SELECT NVL(SUM(fee_paid), 0)
    INTO v_total_revenue
    FROM registrations
    WHERE event_id = p_event_id AND status = 'CONFIRMED';

    RETURN ROUND(v_total_revenue, 2);
EXCEPTION
    WHEN OTHERS THEN
        RETURN 0.00;
END FN_CALCULATE_EVENT_REVENUE;
/

-- 3. STORED PROCEDURE: Cancel Registration & Promote Waitlist
CREATE OR REPLACE PROCEDURE SP_CANCEL_REGISTRATION (
    p_reg_id        IN  NUMBER,
    p_refund_amount OUT NUMBER
) AS
    v_event_id NUMBER;
    v_status VARCHAR2(20);
    v_waitlist_reg_id NUMBER := NULL;
BEGIN
    SELECT event_id, status, fee_paid
    INTO v_event_id, v_status, p_refund_amount
    FROM registrations
    WHERE registration_id = p_reg_id;

    IF v_status = 'CANCELLED' THEN
        RAISE_APPLICATION_ERROR(-20004, 'Registration is already cancelled.');
    END IF;

    -- Update to CANCELLED
    UPDATE registrations
    SET status = 'CANCELLED'
    WHERE registration_id = p_reg_id;

    IF v_status = 'CONFIRMED' THEN
        -- Check if someone is on the waitlist for this event
        BEGIN
            SELECT registration_id INTO v_waitlist_reg_id
            FROM (SELECT registration_id
                  FROM registrations
                  WHERE event_id = v_event_id AND status = 'WAITLISTED'
                  ORDER BY registration_date ASC)
            WHERE ROWNUM = 1;

            -- Promote waitlisted student to CONFIRMED
            UPDATE registrations
            SET status = 'CONFIRMED',
                ticket_code = REPLACE(ticket_code, 'WLIST-', 'TKT-')
            WHERE registration_id = v_waitlist_reg_id;

            DBMS_OUTPUT.PUT_LINE('[PL/SQL] Promoted waitlisted registration #' || v_waitlist_reg_id || ' to CONFIRMED.');
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                -- No one on waitlist, simply decrement current_registrations
                UPDATE events 
                SET current_registrations = current_registrations - 1 
                WHERE event_id = v_event_id;
        END;
    END IF;

    COMMIT;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        ROLLBACK;
        RAISE_APPLICATION_ERROR(-20005, 'Registration #' || p_reg_id || ' not found.');
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE;
END SP_CANCEL_REGISTRATION;
/
