with 

source as (

    select * from {{ ref('stg_financiera__account') }}

),

final as (

    select
        account_id,
        payment_frequency,
        created_at,
    from source

)

select * from final
