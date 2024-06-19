{% macro obtener_casos_sum(valores=[]) %}
    {%- set casos_sum = [] %}
    {%- for operation_type in valores %}
        {% set caso_sum = "SUM(CASE WHEN o.operation_type = trim('" ~ operation_type ~ "') THEN 1 ELSE 0 END) AS " ~ operation_type | lower() %}
        {%- do casos_sum.append(caso_sum) %}
    {%- endfor %}
    {{ casos_sum | join(', ') }}
{% endmacro %}

