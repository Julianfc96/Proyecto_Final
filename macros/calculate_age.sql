{% macro calculate_age(birth_date) %}
    DATEDIFF('year', {{ birth_date }}, '1998-12-31'::date)
{% endmacro %}
