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
        operation_date,
        operation_id,
        amount_EUR,
        balance_EUR,
        trans_desc,
        partner_bank_id


    from source 
)

select * from renamed
