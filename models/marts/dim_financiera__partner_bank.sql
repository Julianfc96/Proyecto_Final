{{ config(
    materialized='incremental',
    unique_key='partner_bank_id'
) }}
with 

source as (
    select * from {{ ref('int_financiera__trans') }}
),

final as (
    select 
        partner_bank_id,
        partner_bank, 
        partner_account,
        case
            when partner_bank_id is null or partner_bank_id = '' or partner_bank is null or partner_bank = '' or partner_account is null or partner_account = ''
            then null
            else date_load
        end as date_load,
        row_number() over (partition by partner_bank_id, partner_bank, partner_account order by date_load) as row_num
    from source
    where not (
        (partner_bank_id is null or partner_bank_id = '') and
        (partner_bank is null or partner_bank = '') and
        (partner_account is null or partner_account = '') and
        (date_load is null)
    )
),

filtro_final as (
    select     
        partner_bank_id,
        partner_bank, 
        partner_account,
        date_load,
        from final
    where row_num = 1 and date_load is not null 
)

select * from filtro_final
    {% if is_incremental() %}
        where date_load > (select max(date_load) from {{ this }})
    {% endif %}