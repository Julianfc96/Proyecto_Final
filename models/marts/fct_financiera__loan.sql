{{ config(
    materialized='incremental',
    unique_key='loan_id'
) }}
with 

source as (
    select * from {{ ref('int_financiera__loan') }}
),


final as (
    select
        loan_id,
        account_id,
        loan_create_at,
        card_id,
        client_id,
        district_id,
        amount_EUR,
        estimated_end_date,
        payments_EUR,
        status_id,
        date_load
    from source 
    {% if is_incremental() %}
        where date_load > (select max(date_load) from {{ this }})
    {% endif %}
)

select * from final
