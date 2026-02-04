-- =====================================================
-- Customer Support Ticket Analysis System
-- Database: support_db
-- Table: support_tickets
-- =====================================================


-- 1. Total number of support tickets
SELECT COUNT(*) AS total_tickets
FROM support_tickets;


-- 2. Preview unresolved tickets (open or in progress)
SELECT *
FROM support_tickets
WHERE resolved_date IS NULL
LIMIT 10;


-- 3. Ticket distribution by issue type
SELECT issue_type, COUNT(*) AS total_tickets
FROM support_tickets
GROUP BY issue_type
ORDER BY total_tickets DESC;


-- 4. Ticket distribution by priority
SELECT priority, COUNT(*) AS total_tickets
FROM support_tickets
GROUP BY priority
ORDER BY total_tickets DESC;


-- 5. Ticket distribution by status
SELECT status, COUNT(*) AS total_tickets
FROM support_tickets
GROUP BY status;


-- 6. Average resolution time by issue type
SELECT issue_type,
       AVG(DATEDIFF(resolved_date, created_date)) AS avg_resolution_days
FROM support_tickets
WHERE resolved_date IS NOT NULL
GROUP BY issue_type
ORDER BY avg_resolution_days DESC;


-- 7. Average resolution time by department
SELECT department,
       AVG(DATEDIFF(resolved_date, created_date)) AS avg_resolution_days
FROM support_tickets
WHERE resolved_date IS NOT NULL
GROUP BY department
ORDER BY avg_resolution_days DESC;


-- 8. Department-wise ticket workload
SELECT department, COUNT(*) AS total_tickets
FROM support_tickets
GROUP BY department
ORDER BY total_tickets DESC;


-- 9. High-priority tickets that are not resolved
SELECT *
FROM support_tickets
WHERE priority = 'High'
  AND status != 'Closed';


-- 10. Count of high-priority unresolved tickets
SELECT COUNT(*) AS high_priority_unresolved
FROM support_tickets
WHERE priority = 'High'
  AND status != 'Closed';


-- 11. Oldest unresolved tickets (SLA risk analysis)
SELECT ticket_id, issue_type, priority, department, created_date
FROM support_tickets
WHERE resolved_date IS NULL
ORDER BY created_date
LIMIT 10;


-- 12. Monthly ticket trend (volume analysis)
SELECT 
    MONTH(created_date) AS month,
    COUNT(*) AS total_tickets
FROM support_tickets
GROUP BY MONTH(created_date)
ORDER BY month;


-- 13. Monthly resolved ticket trend
SELECT 
    MONTH(resolved_date) AS month,
    COUNT(*) AS resolved_tickets
FROM support_tickets
WHERE resolved_date IS NOT NULL
GROUP BY MONTH(resolved_date)
ORDER BY month;


-- 14. Customer satisfaction by issue type
SELECT issue_type,
       AVG(satisfaction_rating) AS avg_satisfaction
FROM support_tickets
GROUP BY issue_type
ORDER BY avg_satisfaction DESC;


-- 15. Customer satisfaction by department
SELECT department,
       AVG(satisfaction_rating) AS avg_satisfaction
FROM support_tickets
GROUP BY department
ORDER BY avg_satisfaction DESC;


-- 16. Tickets with very low satisfaction (critical quality issues)
SELECT *
FROM support_tickets
WHERE satisfaction_rating <= 2;


-- 17. Customers who raised the most tickets
SELECT customer_id, COUNT(*) AS total_tickets
FROM support_tickets
GROUP BY customer_id
ORDER BY total_tickets DESC
LIMIT 5;


-- 18. Average resolution time for high-priority tickets
SELECT AVG(DATEDIFF(resolved_date, created_date)) AS avg_high_priority_resolution
FROM support_tickets
WHERE priority = 'High'
  AND resolved_date IS NOT NULL;


-- 19. Issue types contributing to most high-priority tickets
SELECT issue_type, COUNT(*) AS high_priority_tickets
FROM support_tickets
WHERE priority = 'High'
GROUP BY issue_type
ORDER BY high_priority_tickets DESC;


-- 20. Department-wise high-priority ticket load
SELECT department, COUNT(*) AS high_priority_tickets
FROM support_tickets
WHERE priority = 'High'
GROUP BY department
ORDER BY high_priority_tickets DESC;


-- 21. Resolution performance bucket (Fast vs Slow)
SELECT 
    CASE 
        WHEN DATEDIFF(resolved_date, created_date) <= 3 THEN 'Fast Resolution'
        ELSE 'Slow Resolution'
    END AS resolution_category,
    COUNT(*) AS ticket_count
FROM support_tickets
WHERE resolved_date IS NOT NULL
GROUP BY resolution_category;


-- 22. Percentage of unresolved tickets
SELECT 
    ROUND(
        (SUM(CASE WHEN resolved_date IS NULL THEN 1 ELSE 0 END) / COUNT(*)) * 100,
        2
    ) AS unresolved_percentage
FROM support_tickets;


-- 23. Tickets created but never closed (potential backlog)
SELECT COUNT(*) AS backlog_tickets
FROM support_tickets
WHERE status IN ('Open', 'In Progress');


-- 24. Rank tickets by satisfaction within each department (Window Function)
SELECT ticket_id,
       department,
       satisfaction_rating,
       RANK() OVER (PARTITION BY department ORDER BY satisfaction_rating DESC) AS satisfaction_rank
FROM support_tickets;


-- 25. Rank departments by average resolution time (Management KPI)
SELECT department,
       AVG(DATEDIFF(resolved_date, created_date)) AS avg_resolution_days,
       RANK() OVER (ORDER BY AVG(DATEDIFF(resolved_date, created_date))) AS department_rank
FROM support_tickets
WHERE resolved_date IS NOT NULL
GROUP BY department;


-- =====================================================
-- END OF ANALYSIS
-- =====================================================
