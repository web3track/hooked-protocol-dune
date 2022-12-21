-- wild-cash-uhgtoken-withdraw-sell-daily
with
  withdraw as (
    select distinct
      `to` as address
    from
      wild_cash_bnb.uHGToken_evt_Transfer
    where
      `from` = '0x0000000000000000000000000000000000000000'
  ),
  sell_d as (
    select
      date_trunc('day', tr.evt_block_time) as day,
      sum(tr.value / 1e18) as amount
    from
      withdraw
      left join wild_cash_bnb.uHGToken_evt_Transfer tr on tr.`from` = withdraw.address
    where
      tr.`to` = '0x82a415261584a12089b5a4ec73ac58276f7509c0'
    group by
      1
    order by
      1
  )
select
  *,
  sum(amount) over (
    order by
      day
  ) as accumulate_amount
from
  sell_d
order by
  day