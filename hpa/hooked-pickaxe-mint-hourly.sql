-- hooked-pickaxe-mint-hourly
select
  count(*) as amount,
  date_trunc('hour', evt_block_time) as hourly
from
  hookedprotocal_bnb.HookedPickaxe_evt_Transfer
where
  `from` = '0x0000000000000000000000000000000000000000'
group by
  date_trunc('hour', evt_block_time)