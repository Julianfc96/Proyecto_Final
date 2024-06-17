{{ config(
    materialized='incremental',
    unique_key='card_id'
) }}

with 

source as (

    select * from {{ ref('stg_financiera__card') }}

),

final as (

    select
        card_id,
        type_card,
        TO_DATE(issued_at) as issued_at,
        date_load
    from source
    {% if is_incremental() %}
        where date_load > (select max(date_load) from {{ this }})
    {% endif %}
)

select * from final
