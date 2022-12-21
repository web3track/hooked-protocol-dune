-- hooked-pickaxe-transaction-total
select
  count(*) as tr_amount,
  count(distinct `from`) as user_amount
from
  bnb.transactions
where
  block_time >= '2022-09-27'
  and `to` = '0x3d24c45565834377b59fceaa6864d6c25144ad6c'