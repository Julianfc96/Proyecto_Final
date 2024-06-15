{% macro filtrar_registros(model_ref, condition_column, condition_value) %}
{{ config(
    materialized='view',
    unique_key='filter_{{ model_ref }}_{{ condition_column }}_{{ condition_value }}'
) }}

with source_table as (
    select * from {{ model_ref }}
)

select *
from source_table
where {{ condition_column }} = '{{ condition_value }}'
{% endmacro %}
