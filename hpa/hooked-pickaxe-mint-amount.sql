-- hooked-pickaxe-mint-amount
select
  count(*) as amount
from
  hookedprotocal_bnb.HookedPickaxe_evt_Transfer
where
  "from" = '0x0000000000000000000000000000000000000000'