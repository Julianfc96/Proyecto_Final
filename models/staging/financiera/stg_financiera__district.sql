{{ config(
    materialized='incremental',
    unique_key='district_id'
) }}

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
    
    {% if is_incremental() %}
        where date_load > (select max(date_load) from {{ this }})
    {% endif %}
)

select * from renamed
order by district_id