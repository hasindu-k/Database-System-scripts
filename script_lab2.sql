create type dept_t
/

create type emp_t AS OBJECT(
	EMPNO CHAR(6),
	FIRSTNAME VARCHAR(12),
	LASTNAME VARCHAR(15),
	WORKDEPT REF dept_t,
	SEX CHAR(1),
	BIRTHDATE DATE,
	SALARY NUMBER(8,2)
)
/

create type dept_t AS OBJECT(
	DEPTNO CHAR(3),
	DEPTNAME VARCHAR(36),
	MGRNO REF emp_t,
	ADMRDEPT REF dept_t
)
/

--create tables

create table OREMP of emp_t(
	constraint OREMP_PK PRIMARY KEY(EMPNO),
	constraint OREMP_FIRSTNAME_NN FIRSTNAME NOT NULL,
	constraint OREMP_LASTNAME_NN LASTNAME NOT NULL,
	constraint OREMP_SEC_CK CHECK (SEX='M' OR SEX='F' OR SEX='m' OR SEX='f')
)
/

create table ORDEPT of dept_t(
	constraint ORDEPT_PK PRIMARY KEY(DEPTNO),
	constraint ORDEPT_DEPTNAME_NN DEPTNAME NOT NULL,
	constraint ORDEPT_MGRNO_FK FOREIGN KEY(MGRNO) REFERENCES OREMP,
	constraint ORDEPT_ADMRDEPT_FK FOREIGN KEY(ADMRDEPT) REFERENCES ORDEPT
)
/

ALTER TABLE OREMP
ADD constraint OREMP_WORKDEPT_FK FOREIGN KEY(WORKDEPT) REFERENCES ORDEPT
/


--Inserting OREMP table data

insert into ORDEPT values(DEPT_T('A00', 'SPIFFY COMPUTER SERVICE DIV', null, null))
/

insert into ORDEPT values(DEPT_T('B01', 'Planning', null,(select ref(d) from ORDEPT d where d.DEPTNO='A00')))
/
insert into ORDEPT values(DEPT_T('C01', 'Infromation Center', null,(select ref(d) from ORDEPT d where d.DEPTNO='A00')))
/
insert into ORDEPT values(DEPT_T('D01', 'Development Center', null,(select ref(d) from ORDEPT d where d.DEPTNO='C01')))
/

update ORDEPT d 
set d.ADMRDEPT = (select ref(d) from ORDEPT d where d.DEPTNO = 'A00')
where d.DEPTNO = 'A00'
/

--Inserting OREMP table data

insert into OREMP values(EMP_T('000010', 'Christine', 'Haas', (select ref(d) from ORDEPT d where d.DEPTNO = 'A00'), 'F', '14-AUG-1953', 72750))
/
insert into OREMP values(EMP_T('000020', 'Michell', 'Thompson', (select ref(d) from ORDEPT d where d.DEPTNO = 'B01'), 'M', '02-FEB-1968', 61250))
/
insert into OREMP values(EMP_T('000030', 'Sally', 'Kwan', (select ref(d) from ORDEPT d where d.DEPTNO = 'C01'), 'F', '11-MAY-1971', 58250))
/
insert into OREMP values(EMP_T('000060', 'Irving', 'Stern', (select ref(d) from ORDEPT d where d.DEPTNO = 'D01'), 'M', '07-JUL-1965', 55555))
/
insert into OREMP values(EMP_T('000070', 'Eva', 'Pulaksi', (select ref(d) from ORDEPT d where d.DEPTNO = 'D01'), 'F', '26-MAY-1973', 56170))
/
insert into OREMP values(EMP_T('000050', 'Jhon', 'Geyer', (select ref(d) from ORDEPT d where d.DEPTNO = 'C01'), 'M', '15-SEP-1955', 60175))
/
insert into OREMP values(EMP_T('000090', 'Eileen', 'Henderson', (select ref(d) from ORDEPT d where d.DEPTNO = 'B01'), 'F', '15-MAY-1961', 49750))
/
insert into OREMP values(EMP_T('000100', 'Theodore', 'Spenser', (select ref(d) from ORDEPT d where d.DEPTNO = 'B01'), 'M', '18-AUG-1976', 46150))
/


update ORDEPT d 
set d.MGRNO = (select ref(e) from OREMP e where e.EMPNO = '000010')
where d.DEPTNO = 'A00'
/
update ORDEPT d 
set d.MGRNO = (select ref(e) from OREMP e where e.EMPNO = '000020')
where d.DEPTNO = 'B01'
/
update ORDEPT d 
set d.MGRNO = (select ref(e) from OREMP e where e.EMPNO = '000030')
where d.DEPTNO = 'C01'
/
update ORDEPT d 
set d.MGRNO = (select ref(e) from OREMP e where e.EMPNO = '000060')
where d.DEPTNO = 'D01'
/


--Q2

--a)
SELECT d.deptname AS department_name,d.mgrno.lastname AS manager_lastname
FROM ORDEPT d
ORDER BY d.DEPTNAME
/

--b)
SELECT e.empno AS employee_number,e.LASTNAME AS employee_lastname,e.workdept.deptname AS department_name
FROM OREMP e
ORDER BY e.EMPNO
/

--c)
SELECT d.deptno, d.deptname, d.admrdept.deptname AS administration_dept
FROM ORDEPT d
/
	
--d)
SELECT d.deptno, d.deptname, d.admrdept.deptname, d.admrdept.mgrno.lastname
FROM ORDEPT d
/
 
--e)
SELECT e.empno,e.firstname,e.lastname,e.salary,
e.workdept.mgrno.lastname as manager_lastname,
e.workdept.mgrno.salary as manager_slary
FROM OREMP e
/

--f)
SELECT e.workdept.deptno AS DEPARTMENT_NO, e.workdept.deptname AS DEPARTMENT_NAME, e.sex AS SEX,  AVG(e.salary) AS AVG_SALARY
FROM OREMP e
GROUP BY e.workdept.deptno, e.workdept.deptname, e.sex
ORDER BY e.workdept.deptno
/