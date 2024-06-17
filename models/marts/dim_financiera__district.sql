{{ config(
    materialized='incremental',
    unique_key='district_id'
) }}

with 

source as (

    select * from {{ ref('stg_financiera__district') }}

),

renamed as (

    select
        district_id, 
        district_name,
        region,
        date_load

    from source
    {% if is_incremental() %}
        where date_load > (select max(date_load) from {{ this }})
    {% endif %}
)

select * from renamed
