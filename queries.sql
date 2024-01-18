-- 1. Print the names of professors who work in departments that have fewer than 50 PhD students
=======>
SELECT prof.pname FROM prof JOIN dept ON prof.dname = dept.dname WHER
E dept.numphds < 50;
   pname
------------
 Brian, C.
 Edison, L.
 Bucket, T.
 Walter, A.
 Jones, J.
 Smith, S.
----------------------------------
-- 2.Print the names of the students with the lowest GPA.
=======>
SELECT s.sname FROM student s WHERE s.gpa = (SELECT MIN(gpa)FROM stud
ent);
        sname
----------------------
 Jetplane, Leaving O.
(1 row)
----------------------------------
-- 3. For each Computer Sciences class, print the class number, section number, and the average gpa of the students enrolled in the class section.
========>
---------------------------------
-- 4. Print the names and section numbers of all sections with more than six students enrolled in them
========>
 SELECT
     s.pname AS professor_name,
     s.sectno AS section_number
 FROM
     section s
 JOIN enroll e ON s.dname = e.dname AND s.cno = e.cno AND s.sectno = e
.sectno
 GROUP BY
     s.pname, s.sectno
 HAVING
     COUNT(e.sid) > 6;
 professor_name | section_number
----------------+----------------
 Edison, L.     |              1
(1 row)
------------------------------------------
-- 5. Print the name(s) and sid(s) of the student(s) enrolled in the most sections.
========>
 WITH EnrollCounts AS (
     SELECT
         e.sid,
         COUNT(*) AS section_count
     FROM
         enroll e
     GROUP BY
         e.sid
 )

 SELECT
     s.sname,
     s.sid
 FROM
     EnrollCounts ec
 JOIN student s ON ec.sid = s.sid
 WHERE
     ec.section_count = (SELECT MAX(section_count) FROM EnrollCounts);

    sname     | sid
--------------+-----
 Hamilton, S. |  29
(1 row)
-------------------------------------------
-- 6. Print the names of departments that have one or more majors who are under 18 years old.
=======>
 SELECT DISTINCT
     d.dname
 FROM
     dept d
 JOIN major m ON d.dname = m.dname
 JOIN student s ON m.sid = s.sid
 WHERE
     s.age < 18;
         dname
------------------------
 Industrial Engineering
 Mathematics
(2 rows)
-----------------------------------------------
-- 7. Print the names and majors of students who are taking one of the College Geometry courses
========>
SELECT DISTINCT
     s.sname,
     m.dname AS major
 FROM
     student s
 JOIN major m ON s.sid = m.sid
 JOIN enroll e ON s.sid = e.sid
 JOIN course c ON e.cno = c.cno
 WHERE
     c.cname LIKE 'College Geometry%';
       sname       |        major
-------------------+----------------------
 Atny, Mary H.     | Civil Engineering
 Austin, G.        | Chemical Engineering
 Bates, Michael L. | Mathematics
 Cheong, R.        | Computer Sciences
 Davis, Scott P.   | Mathematics
 Dunbar, D.        | Civil Engineering
 Ford, Gerald      | Chemical Engineering
 Ghandi, I.        | Mathematics
 Glitch, R.        | Civil Engineering
 Gooch             | Computer Sciences
 Mathews, John W.  | Chemical Engineering
 Rosemeyer, S.     | Civil Engineering
 Smith, L.         | Computer Sciences
 Sulfate, Barry M. | Computer Sciences
 Thorton, James Q. | Computer Sciences
 Uoiea, Z.         | Mathematics
 Zappa, F.         | Mathematics
 Ziebart, F.       | Civil Engineering
(18 rows)
--------------------------------------------------
-- 8. For those departments that have no major taking a College Geometry course print the department name and the number of PhD students in the department
=======>
 SELECT
     d.dname AS department_name,
     COUNT(s.sid) AS num_phd_students
 FROM
     dept d
 LEFT JOIN major m ON d.dname = m.dname
 LEFT JOIN student s ON m.sid = s.sid
 LEFT JOIN enroll e ON s.sid = e.sid
 LEFT JOIN course c ON e.cno = c.cno
 WHERE
     c.cname LIKE 'College Geometry%'
     AND d.numphds > 0
 GROUP BY
     d.dname;
   department_name    | num_phd_students
----------------------+------------------
 Chemical Engineering |                3
 Civil Engineering    |                5
 Computer Sciences    |                5
 Mathematics          |                5
(4 rows)
-------------------------------------------------
-- 9.Print the names of students who are taking both a Computer Sciences course and a Mathematics course
======>
SELECT DISTINCT
     s.sname
 FROM
     student s
 JOIN enroll e1 ON s.sid = e1.sid
 JOIN course c1 ON e1.cno = c1.cno AND e1.dname = c1.dname
 JOIN enroll e2 ON s.sid = e2.sid
 JOIN course c2 ON e2.cno = c2.cno AND e2.dname = c2.dname
 WHERE
     c1.dname = 'Computer Sciences'
     AND c2.dname = 'Mathematics';
   sname
-----------
 Zappa, F.
(1 row)
------------------------------------------------------
-- 10.Print the age difference between the oldest and the youngest Computer Sciences major
=======>
SELECT
     MAX(age) - MIN(age) AS age_difference
 FROM
     student
 WHERE
     sid IN (
         SELECT
             m.sid
         FROM
             major m
         WHERE
             m.dname = 'Computer Sciences'
            );
 age_difference
----------------
             38
(1 row)
-----------------------------------------
-- 11.For each department that has one or more majors with a GPA under 1.0, print the name of the department and the average GPA of its majors
=======>
WITH LowGpaDepartments AS (
     SELECT DISTINCT
         m.dname
     FROM
         major m
     JOIN
         student s ON m.sid = s.sid
     WHERE
         s.gpa < 1.0
)

 SELECT
     d.dname AS department_name,
     AVG(s.gpa) AS average_gpa
 FROM
     LowGpaDepartments d
 JOIN
     major m ON d.dname = m.dname
 JOIN
     student s ON m.sid = s.sid
 GROUP BY
     d.dname;
    department_name     |    average_gpa
------------------------+--------------------
 Civil Engineering      | 2.9142857236521587
 Industrial Engineering | 2.7699999906122685
 Computer Sciences      | 3.0041666651765504
(3 rows)
------------------------------------------------------
-- 12.Print the ids, names and GPAs of the students who are currently taking all the Civil Engineering courses.
=======>
 WITH CivilEngineeringCourses AS (
     SELECT
         cno
     FROM
         course
     WHERE
         dname = 'Civil Engineering'
 )

 SELECT
     s.sid AS student_id,
     s.sname AS student_name,
     s.gpa
 FROM
     student s
 JOIN
     enroll e ON s.sid = e.sid
 WHERE
     NOT EXISTS (
         SELECT
             cno
         FROM
             CivilEngineeringCourses ce
         EXCEPT
         SELECT
             e2.cno
         FROM
             enroll e2
         WHERE
             e2.sid = s.sid
     );
 student_id |   student_name    |        gpa
------------+-------------------+-------------------
         29 | Hamilton, S.      | 2.799999952316284
         29 | Hamilton, S.      | 2.799999952316284
         29 | Hamilton, S.      | 2.799999952316284
         66 | Altenhaus, Stuart | 2.799999952316284
         66 | Altenhaus, Stuart | 2.799999952316284
(5 rows)
----------------------------------------------------------------










