-- Active: 1709313903919@@127.0.0.1@3306@waizly
-- Create Database waizly
CREATE DATABASE waizly;

CREATE TABLE employees (
    employee_id INTEGER AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255),
    job_title VARCHAR(255) NOT NULL,
    salary INTEGER NOT NULL,
    department VARCHAR(255) NOT NULL, 
    joined_date DATE 
);

CREATE TABLE sales_data (
    sales_id INTEGER AUTO_INCREMENT PRIMARY KEY,
    employee_id INTEGER NOT NULL,
    sales INTEGER NOT NULL,
    FOREIGN KEY (employee_id) REFERENCES employees (employee_id)
);

-- Insert employees and sales_data records
INSERT INTO employees (name, job_title, salary, department, joined_date) VALUES
    ('John Smith', 'Manager', 60000, 'Sales', '2022-01-15'),
    ('Jane Doe', 'Analyst', 45000, 'Marketing', '2022-02-01'),
    ('Mike Brown', 'Developer', 55000, 'IT', '2022-03-10'),
    ('Anna Lee', 'Manager', 65000, 'Sales', '2021-12-05'),
    ('Mark Wong', 'Developer', 50000, 'IT', '2023-05-20'),
    ('Emily Chen', 'Analyst', 48000, 'Marketing', '2023-06-02');

INSERT INTO sales_data (employee_id, sales) VALUES
    (1, 15000),
    (2, 12000),
    (3, 18000),
    (1, 20000),
    (4, 22000),
    (5, 19000),
    (6, 13000),
    (2, 14000);

-- 1. Tampilkan seluruh data dari tabel "employees" (5 Points)
SELECT * FROM employees;

-- 2. Berapa banyak karyawan yang memiliki posisi pekerjaan (job title) "Manager"? (5 Points)
SELECT COUNT(*) AS manager_count
FROM employees
WHERE
    job_title = 'Manager';

-- 3. Tampilkan daftar nama dan gaji (salary) dari karyawan yang bekerja di departemen "Sales" atau "Marketing" (10 Points)
SELECT name, salary
FROM employees
WHERE
    department IN ('Sales', 'Marketing');

-- 4. Hitung rata-rata gaji (salary) dari karyawan yang bergabung (joined) dalam 5 tahun terakhir (berdasarkan kolom "joined_date") (10 Points)
SELECT AVG(salary) AS avg_salary
FROM employees
WHERE
    joined_date >= (CURRENT_DATE - INTERVAL 5 YEAR);

-- 5. Tampilkan 5 karyawan dengan total penjualan (sales) tertinggi dari tabel "employees" dan "sales_data" (10 Points)
SELECT e.name, SUM(sd.sales) AS total_sales
FROM employees e
    JOIN sales_data sd ON e.employee_id = sd.employee_id
GROUP BY
    e.name
ORDER BY total_sales DESC
LIMIT 5;

-- 6. Tampilkan nama, gaji (salary), dan rata-rata gaji (salary) dari semua karyawan yang bekerja di departemen yang memiliki rata-rata gaji lebih tinggi dari gaji rata-rata di semua departemen (15 Points)
SELECT name, salary, (SELECT AVG(salary) FROM employees) AS avg_salary
FROM employees e
GROUP BY
    name,
    salary
HAVING
    salary > avg_salary;

-- 7. Tampilkan nama dan total penjualan (sales) dari setiap karyawan, bersama dengan peringkat (ranking) masing-masing karyawan berdasarkan total penjualan. Peringkat 1 adalah karyawan dengan total penjualan tertinggi (25 Points)
SELECT name, total_sales, RANK() OVER (
        ORDER BY total_sales DESC
    ) AS ranking
FROM (
        SELECT e.name, SUM(sd.sales) AS total_sales
        FROM employees e
            JOIN sales_data sd ON e.employee_id = sd.employee_id
        GROUP BY
            e.name
    ) AS sales_data_ranked;

-- 8. Buat sebuah stored procedure yang menerima nama departemen sebagai input, dan mengembalikan daftar karyawan dalam departemen tersebut bersama dengan total gaji (salary) yang mereka terima (20 Points)CREATE OR REPLACE FUNCTION get_department_employees(department_name VARCHAR)
DELIMITER $$
CREATE PROCEDURE get_department_employees (IN department_name VARCHAR(255))
BEGIN
    SELECT e.name, SUM(e.salary) AS total_salary
    FROM employees e
    WHERE e.department = department_name
    GROUP BY e.name;
END$$
DELIMITER ;

CALL get_department_employees('Sales');


