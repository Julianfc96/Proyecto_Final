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
        duration,
        payments_EUR,
        status_id,
    from source 
)

select * from final

-- prestamos según si pagan semanal o mensual