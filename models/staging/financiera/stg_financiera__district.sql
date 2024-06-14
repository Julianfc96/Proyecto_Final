with 

source as (

    select * from {{ source('financiera', 'district') }}

),

renamed as (

    select
        a1 as district_id, --Distrito financiero, sucursal del cliente
        a2 as district_name,
        a3 as region,
        _fivetran_deleted as data_deleted,
        _fivetran_synced as date_load

    from source

)

select * from renamed
