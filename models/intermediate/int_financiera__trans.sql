{{ config(
    materialized='incremental',
    unique_key='trans_id'
) }}
with 

source as (

    select * from {{ ref('stg_financiera__trans') }}

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
        max(client_id) as client_id
    from {{ ref('stg_financiera__client_disp') }}
    group by account_id
),

account as (
    select * from {{ ref('stg_financiera__account')}}
),

renamed as (

    select
        l.trans_id,
        l.account_id,
        l.trans_date,
        l.operation_id,
        l.operation,
        l.operation_type,
        l.amount_EUR,
        ROUND(CASE
            WHEN COALESCE(l.balance_eur - LAG(l.balance_eur) OVER (PARTITION BY l.account_id ORDER BY l.trans_date), 0) = 0
                THEN l.amount_eur
            ELSE COALESCE(l.balance_eur - LAG(l.balance_eur) OVER (PARTITION BY l.account_id ORDER BY l.trans_date), 0)
        END, 2) AS cambio_balance,
        l.balance_EUR,
        l.trans_desc,
        CASE 
            WHEN l.partner_bank is not null THEN {{dbt_utils.generate_surrogate_key(['partner_bank','partner_account'])}}
            ELSE null
        END as partner_bank_id,
        l.partner_bank,
        l.partner_account,
        l.data_deleted,
        l.date_load,
        c.card_id,
        d.client_id,
        a.district_id,

    from source l
    left join disp d on l.account_id = d.account_id
    left join card c on d.disp_id = c.disp_id 
    left join account a on l.account_id = a.account_id
    {% if is_incremental() %}
    where l.date_load > (select max(date_load) from {{ this }})
    {% endif %}
)

select * from renamed
