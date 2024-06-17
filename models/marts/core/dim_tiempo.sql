WITH dates AS (
    SELECT
        DATEADD(day, SEQ4(), '1993-01-01') AS date
    FROM
        TABLE(GENERATOR(ROWCOUNT => 5000)) 
),

final AS (
    SELECT
        {{dbt_utils.generate_surrogate_key(['date::date'])}} as time_id,
        date::date as date,
        extract(year from date) as year,
        extract(month from date) as month,
        monthname(date) as month_name,
        extract(day from date) as day,
        extract(dayofweek from date) as number_week_day,
        dayname(date) as week_day,
        extract(quarter from date) as quarter
    FROM
        dates
    WHERE date::date BETWEEN '1993-01-01' AND '2003-12-31'
)

SELECT * FROM final




