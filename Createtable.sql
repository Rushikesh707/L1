-- Create student table
CREATE TABLE student (
    sid INT PRIMARY KEY,
    sname VARCHAR(255),
    sex CHAR(1),
    age INT,
    year INT,
    gpa FLOAT
);

-- Create dept table
CREATE TABLE dept (
    dname VARCHAR(255) PRIMARY KEY,
    numphds INT
);

-- Create prof table with unique constraint on (dname, pname)
CREATE TABLE prof (
    pname VARCHAR(255) PRIMARY KEY,
    dname VARCHAR(255) REFERENCES dept(dname),
    UNIQUE (dname, pname)
);

-- Create course table
CREATE TABLE course (
    cno INT PRIMARY KEY,
    dname VARCHAR(255) REFERENCES dept(dname),
    cname VARCHAR(255)
);

-- Create major table
CREATE TABLE major (
    dname VARCHAR(255) REFERENCES dept(dname),
    sid INT REFERENCES student(sid),
    PRIMARY KEY (dname, sid)
);

-- Create section table
CREATE TABLE section (
    dname VARCHAR(255) REFERENCES dept(dname),
    cno INT REFERENCES course(cno),
    sectno INT,
    pname VARCHAR(255),
    PRIMARY KEY (dname, cno, sectno),
    FOREIGN KEY (dname, pname) REFERENCES prof(dname, pname)
);

-- Create enroll table
CREATE TABLE enroll (
    sid INT REFERENCES student(sid),
    dname VARCHAR(255) REFERENCES dept(dname),
    cno INT REFERENCES course(cno),
    sectno INT,
    grade CHAR(1),
    PRIMARY KEY (sid, dname, cno, sectno),
    FOREIGN KEY (dname, cno, sectno) REFERENCES section(dname, cno, sectno)
);
