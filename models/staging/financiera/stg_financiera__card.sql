with 

source as (

    select * from {{ source('financiera', 'card') }}

),

renamed as (

    select
        card_id,
        disp_id,
        type as type_card,
        TO_TIMESTAMP(ISSUED, 'YYMMDD HH24:MI:SS') AS issued_at,
        _fivetran_deleted as data_deleted,
        _fivetran_synced as date_load

    from source

)

select * from renamed   
