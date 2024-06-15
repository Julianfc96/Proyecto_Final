{% macro convert_to_eur(numeric_field) %}
    round({{ numeric_field }} * 0.040, 2) AS {{ numeric_field }}_eur
{% endmacro %}