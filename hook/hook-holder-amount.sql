-- hook-holder-amount
with
  transfer_detail as (
    select
      `to` as address,
      value as amount
    from
      hookedprotocal_bnb.HookToken_evt_Transfer
    union all
    select
      `from` as address,
      -1 * value as amount
    from
      hookedprotocal_bnb.HookToken_evt_Transfer
  ),
  address_balance as (
    select
      address,
      sum(amount / 1e18) as balance_amount
    from
      transfer_detail
    group by
      1
  )
select
  count(*) as holder_amount
from
  address_balance
where
  balance_amount > 0