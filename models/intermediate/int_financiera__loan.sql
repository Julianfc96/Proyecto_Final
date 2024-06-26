{{ config(
    materialized='incremental',
    unique_key='loan_id'
) }}
with 

source as (
    select * from {{ ref('stg_financiera__loan') }}
),

card as (
    select disp_id, max(card_id) as card_id
    from {{ ref('stg_financiera__card') }}
    group by disp_id
),

disp as (
    select
        account_id,
        max(disp_id) as disp_id, -- Suponiendo que queremos el máximo disp_id por account_id
        min(client_id) as client_id
    from {{ ref('stg_financiera__client_disp') }}
    group by account_id
),

account as (
    select * from {{ ref('stg_financiera__account')}}
),

renamed as (
    select
        l.loan_id,
        l.account_id,
        l.loan_create_at,
        l.amount_EUR,
        dateadd(month, estimated_end_date, loan_create_at) as estimated_end_date,
        l.payments_EUR,
        l.status_id,
        l.status,
        l.data_deleted,
        l.date_load,
        c.card_id,
        d.client_id,
        a.district_id
    from source l
    left join disp d on l.account_id = d.account_id
    left join card c on d.disp_id = c.disp_id 
    left join account a on l.account_id = a.account_id
    {% if is_incremental() %}
    where l.date_load > (select max(date_load) from {{ this }})
    {% endif %}
)

select * from renamed

