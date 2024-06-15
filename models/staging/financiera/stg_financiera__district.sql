with 

source as (

    select * from {{ ref('base_financiera__district') }}

),

renamed as (

    select
        district_id, --Distrito financiero, sucursal del cliente
        district_name,
        initcap(region) as region,
        data_deleted,
        date_load

    from source

)

select * from renamed
order by district_id