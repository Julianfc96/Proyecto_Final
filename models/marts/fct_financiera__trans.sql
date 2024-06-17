{{ config(
    materialized='incremental',
    unique_key='trans_id'
) }}
with 

source as (

    select * from {{ ref('int_financiera__trans') }}

),


renamed as (

    select
        trans_id,
        account_id,
        card_id,
        client_id,
        district_id,
        trans_date,
        operation_id,
        cambio_balance as amount_eur,
        balance_EUR,
        trans_desc,
        partner_bank_id,
        date_load

    from source 
    {% if is_incremental() %}
    where date_load > (select max(date_load) from {{ this }})
    {% endif %}
)

select * from renamed
