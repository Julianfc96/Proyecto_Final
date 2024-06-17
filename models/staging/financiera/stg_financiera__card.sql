{{ config(
    materialized='incremental',
    unique_key='card_id'
) }}
with 

source as (

    select * from {{ ref('base_financiera__card') }}

),

renamed as (

    select
        card_id,
        disp_id,
        initcap(type_card) as type_card,
        TO_TIMESTAMP(issued_at, 'YYMMDD HH24:MI:SS') as issued_at,
        data_deleted,
        date_load

    from source
    {% if is_incremental() %}
    where date_load > (select max(date_load) from {{ this }})
    {% endif %}
)

select * from renamed
