with 

source as (

    select * from {{ ref('stg_financiera__card') }}

),

final as (

    select
        card_id,
        disp_id,
        type_card,
        TO_DATE(issued_at) as issued_at
    from source

)

select * from final
