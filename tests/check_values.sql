-- test_check_values.sql

-- Descripción del test
-- Verifica que los totales de montos coincidan con los saldos más recientes por cuenta.

-- Consulta que ejecuta el test
with ranked_transactions as (
    select
        *,
        row_number() over (partition by account_id order by trans_id desc) as row_num
    from {{ ref('stg_financiera__trans') }}
),

last_balance_per_account as (
    select
        account_id,
        balance_eur as last_balance
    from ranked_transactions
    where row_num = 1
),

amount_sums_per_account as (
    select
        account_id,
        round(sum(amount_eur),2) as total_amount
    from {{ ref('stg_financiera__trans') }}
    group by account_id
),

check_values as (
    select
        a.account_id,
        a.total_amount,
        b.last_balance,
        case when a.total_amount = b.last_balance then 'PASS' else 'FAIL' end as test_result
    from amount_sums_per_account a
    join last_balance_per_account b
    on a.account_id = b.account_id
)

-- Seleccionar los resultados del test
select *
from check_values


