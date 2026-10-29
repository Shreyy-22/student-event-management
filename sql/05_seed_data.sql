-- ====================================================================
-- SEED DATA FOR STUDENT EVENT MANAGEMENT
-- Inserts initial events, students, and registrations
-- ====================================================================

-- 1. Insert Campus Events
INSERT INTO events (event_id, title, category, event_date, max_capacity, current_registrations, registration_fee, venue)
VALUES (101, 'CodeSprint 2026 24hr Hackathon', 'Hackathon', DATE '2026-11-15', 50, 0, 15.00, 'CS Lab 3 & Hall B');

INSERT INTO events (event_id, title, category, event_date, max_capacity, current_registrations, registration_fee, venue)
VALUES (102, 'Cloud & AI Architecture Workshop', 'Workshop', DATE '2026-11-20', 30, 0, 25.00, 'Innovation Hub Auditorium');

INSERT INTO events (event_id, title, category, event_date, max_capacity, current_registrations, registration_fee, venue)
VALUES (103, 'Annual Campus Cultural Fest', 'Cultural', DATE '2026-12-05', 200, 0, 10.00, 'Main University Amphitheater');

INSERT INTO events (event_id, title, category, event_date, max_capacity, current_registrations, registration_fee, venue)
VALUES (104, 'Tech Career & Internship Fair', 'Career Fair', DATE '2026-12-12', 150, 0, 0.00, 'Student Recreation Complex');

INSERT INTO events (event_id, title, category, event_date, max_capacity, current_registrations, registration_fee, venue)
VALUES (105, 'Inter-College Chess Championship', 'Sports', DATE '2026-11-28', 4, 0, 5.00, 'Student Union Room 204');

-- 2. Insert Students
INSERT INTO students (student_id, full_name, email, major, year_of_study, phone)
VALUES (201, 'Aria Montgomery', 'aria.m@campus.edu', 'Computer Science', 3, '+1 (555) 234-5678');

INSERT INTO students (student_id, full_name, email, major, year_of_study, phone)
VALUES (202, 'Liam Patel', 'liam.p@campus.edu', 'Data Science', 2, '+1 (555) 345-6789');

INSERT INTO students (student_id, full_name, email, major, year_of_study, phone)
VALUES (203, 'Zoe Washington', 'zoe.w@campus.edu', 'Software Engineering', 4, '+1 (555) 456-7890');

INSERT INTO students (student_id, full_name, email, major, year_of_study, phone)
VALUES (204, 'Ethan Ramirez', 'ethan.r@campus.edu', 'Electrical Engineering', 1, '+1 (555) 567-8901');

INSERT INTO students (student_id, full_name, email, major, year_of_study, phone)
VALUES (205, 'Maya Lin', 'maya.l@campus.edu', 'Information Systems', 3, '+1 (555) 678-9012');

COMMIT;

-- 3. Register initial students via PL/SQL Stored Procedure (Demonstration)
DECLARE
    v_id NUMBER;
    v_ticket VARCHAR2(30);
    v_msg VARCHAR2(100);
BEGIN
    SP_REGISTER_STUDENT_EVENT(201, 101, 15.00, v_id, v_ticket, v_msg);
    SP_REGISTER_STUDENT_EVENT(202, 101, 15.00, v_id, v_ticket, v_msg);
    SP_REGISTER_STUDENT_EVENT(203, 101, 15.00, v_id, v_ticket, v_msg);
    SP_REGISTER_STUDENT_EVENT(201, 102, 25.00, v_id, v_ticket, v_msg);
    SP_REGISTER_STUDENT_EVENT(204, 102, 25.00, v_id, v_ticket, v_msg);
    SP_REGISTER_STUDENT_EVENT(205, 103, 10.00, v_id, v_ticket, v_msg);
    
    -- Fill Chess championship to capacity (4 players)
    SP_REGISTER_STUDENT_EVENT(201, 105, 5.00, v_id, v_ticket, v_msg);
    SP_REGISTER_STUDENT_EVENT(202, 105, 5.00, v_id, v_ticket, v_msg);
    SP_REGISTER_STUDENT_EVENT(203, 105, 5.00, v_id, v_ticket, v_msg);
    SP_REGISTER_STUDENT_EVENT(204, 105, 5.00, v_id, v_ticket, v_msg);
END;
/
