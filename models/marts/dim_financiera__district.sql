with 

source as (

    select * from {{ ref('stg_financiera__district') }}

),

renamed as (

    select
        district_id, 
        district_name,
        region,
        data_deleted,
        date_load

    from source

)

select * from renamed
