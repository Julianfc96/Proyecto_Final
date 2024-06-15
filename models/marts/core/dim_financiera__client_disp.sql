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
        {{ calculate_age('birth_date') }} as age_at_1998
    from source
)

select * from final