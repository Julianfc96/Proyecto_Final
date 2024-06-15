-- macros/convert_date_format.sql

{% macro convert_date_format(date_column) %}
    -- Esta macro convierte una fecha en formato YYMMDD a YYYY-MM-DD
    to_date(
        case
            when {{ date_column }} like '____00' then null
            when length({{ date_column }}) = 6 then
                case
                    when substr({{ date_column }}, 1, 2)::int > 50 then '19' || substr({{ date_column }}, 1, 2) || '-' || substr({{ date_column }}, 3, 2) || '-' || substr({{ date_column }}, 5, 2)
                    else '20' || substr({{ date_column }}, 1, 2) || '-' || substr({{ date_column }}, 3, 2) || '-' || substr({{ date_column }}, 5, 2)
                end
            else null
        end,
        'YYYY-MM-DD'
    )
{% endmacro %}
