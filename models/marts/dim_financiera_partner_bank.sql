with 

source as (

    select * from {{ ref('int_financiera__trans') }}

),

final as (
    
    select distinct 
        {{dbt_utils.generate_surrogate_key(['partner_bank','partner_account'])}} as partner_bank_id,
        partner_bank, 
        partner_account
    from source

)

select * from final