-- wild-cash-uhgtoken-withdraw-daily
select
  date_trunc('day', evt_block_time) as day,
  sum(value / 1e18) as value_amount,
  count(*) as tr_amount,
  count(distinct `to`) as user_amount
from
  wild_cash_bnb.uHGToken_evt_Transfer
where
  `from` = '0x0000000000000000000000000000000000000000'
group by
  1