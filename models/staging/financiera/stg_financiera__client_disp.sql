with 

source_disp as (
    select * from {{ ref('base_financiera__disp') }}
),

renamed_disp as (
    select
        disp_id,
        client_id,
        account_id,
        account_user,
    from source_disp
),

source_client as (
    select * from {{ ref('base_financiera__client') }}
),

renamed_client as (
    select
        client_id,
        district_id,
        gender,
        birth_date,
    from source_client
),

-- Unión de disp y client
combined as (
    select
        d.disp_id,
        d.client_id,
        d.account_id,
        c.district_id,
        c.gender,
        d.account_user,
        c.birth_date
    from renamed_disp d
    left join renamed_client c on d.client_id = c.client_id
)

select * from combined