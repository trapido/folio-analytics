DROP TABLE IF EXISTS folio_reporting.users_departments_unpacked;

-- Create a derived table that takes the user_users table and joins
-- in the group information
CREATE TABLE folio_reporting.users_departments_unpacked AS
WITH departments_array AS (
    SELECT
        uu.id AS user_id,
        departments.data #>> '{}' AS department_id,
        departments.ordinality AS department_ordinality
    FROM
        user_users AS uu
        CROSS JOIN LATERAL json_array_elements(json_extract_path(data, 'departments'))
        WITH ORDINALITY AS departments (data)
)
SELECT
    departments_array.user_id,
    departments_array.department_id,
    departments_array.department_ordinality --,
    --	ud.name AS department_name,
    --	ud.code AS department_code,
    --	ud.usage_number AS department_usage_number
FROM
    departments_array
    --LEFT JOIN user_departments AS ud
    --    ON departments_array.department_id = ud.id
;

CREATE INDEX ON folio_reporting.users_departments_unpacked (user_id);

CREATE INDEX ON folio_reporting.users_departments_unpacked (department_id);

--CREATE INDEX ON folio_reporting.users_departments_unpacked (department_name);

--CREATE INDEX ON folio_reporting.users_departments_unpacked (department_code);

--CREATE INDEX ON folio_reporting.users_departments_unpacked (department_usage_number);

