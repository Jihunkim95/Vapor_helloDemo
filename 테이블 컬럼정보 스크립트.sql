
SELECT
    column_name,
    data_type,
    character_maximum_length,
    column_default,
    is_nullable
FROM
    information_schema.columns
WHERE
    table_schema = 'public' -- 스키마 이름 (기본값은 'public')
    AND table_name = 'users_test'; -- 테이블명