-- hooked-pickaxe-main-transaction-daily
with
  level_up as (
    select
      count(*) as amount,
      date_trunc('day', call_block_time) as day
    from
      hookedprotocal_bnb.HookedPickaxe_call_levelUp
    group by
      date_trunc('day', call_block_time)
  ),
  adventure as (
    select
      count(*) as amount,
      date_trunc('day', call_block_time) as day
    from
      hookedprotocal_bnb.HookedPickaxe_call_adventure
    group by
      date_trunc('day', call_block_time)
  ),
  mint as (
    select
      count(*) as amount,
      date_trunc('day', call_block_time) as day
    from
      hookedprotocal_bnb.HookedPickaxe_call_mint
    group by
      date_trunc('day', call_block_time)
  )
select
  mint.amount as mint_amount,
  level_up.amount as level_up_amount,
  adventure.amount as adventure_amount,
  mint.day as day
from
  mint
  left join level_up on mint.day = level_up.day
  left join adventure on mint.day = adventure.day
order by
  mint.day