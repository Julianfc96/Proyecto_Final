{{ config(
    materialized='incremental',
    unique_key='account_id'
) }}

with 

source as (

    select * from {{ ref('stg_financiera__account') }}

),

final as (

    select
        account_id,
        statement_frequency,
        created_at,
        date_load
    from source
    {% if is_incremental() %}
        where date_load > (select max(date_load) from {{ this }})
    {% endif %}

)

select * from final
