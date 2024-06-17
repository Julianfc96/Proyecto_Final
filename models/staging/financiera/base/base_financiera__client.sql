with 

source as (

    select * from {{ source('financiera', 'client') }}

),

renamed as (

    select
        client_id,
        district_id,
        gender,
        birth_date,
        _fivetran_deleted as data_deleted,
        _fivetran_synced as date_load

    from source
)

select * from renamed
