{{ config(
    materialized='incremental',
    unique_key='client_id'
) }}

with 

source as (
    select * from {{ ref('stg_financiera__client_disp') }}
),


final as (
    select
        client_id,
        gender,
        account_user,
        birth_date,
        {{ calculate_age('birth_date') }} as age_at_1998,
        date_load
    from source
        {% if is_incremental() %}
        where date_load > (select max(date_load) from {{ this }})
        {% endif %}
)

select * from final