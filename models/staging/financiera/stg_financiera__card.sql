with 

source as (

    select * from {{ ref('base_financiera__card') }}

),

renamed as (

    select
        card_id,
        disp_id,
        initcap(type_card) as type_card,
        TO_TIMESTAMP(issued_at, 'YYMMDD HH24:MI:SS') as issued_at,
        data_deleted,
        date_load

    from source

)

select * from renamed
