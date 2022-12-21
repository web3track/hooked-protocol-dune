-- hooked-pickaxe-daily-transaction
with
  all_tr as (
    select
      `from`,
      block_time
    from
      bnb.transactions
    where
      block_time >= '2022-09-27'
      and `to` = '0x3d24c45565834377b59fceaa6864d6c25144ad6c'
  ),
  new_user as (
    select
      `from` as address,
      min(block_time) as min_block_time
    from
      all_tr
    group by
      1
  ),
  tr_d as (
    select
      date_trunc('day', block_time) as day,
      count(*) as tr_amount,
      count(distinct `from`) as user_amount
    from
      all_tr
    group by
      1
    order by
      1
  ),
  new_user_d as (
    select
      date_trunc('day', min_block_time) as day,
      count(*) as amount
    from
      new_user
    group by
      1
    order by
      1
  )
select
  tr_d.*,
  new_user_d.amount as new_user_amount,
  tr_d.user_amount - new_user_d.amount as existing_user_amount,
  sum(tr_d.tr_amount) over (
    order by
      tr_d.day
  ) as accumulate_tr_amount
from
  tr_d
  left join new_user_d on tr_d.day = new_user_d.day
order by
  tr_d.day