-- wild-cash-uhgtoken-withdraw
select
  sum(value / 1e18) as value,
  count(*) as tr_amount,
  count(distinct `to`) as user_amount
from
  wild_cash_bnb.uHGToken_evt_Transfer
where
  `from` = '0x0000000000000000000000000000000000000000'