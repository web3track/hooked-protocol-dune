-- wild-cash-uhgtoken-holder
with
  transfer_detail as (
    select
      `to` as address,
      value as amount
    from
      wild_cash_bnb.uHGToken_evt_Transfer
    union all
    select
      `from` as address,
      -1 * value as amount
    from
      wild_cash_bnb.uHGToken_evt_Transfer
  ),
  address_balance as (
    select
      address,
      sum(amount / 1e18) as balance_amount
    from
      transfer_detail
    group by
      address
  )
select
  count(*) as holder_count
from
  address_balance
where
  balance_amount > 0