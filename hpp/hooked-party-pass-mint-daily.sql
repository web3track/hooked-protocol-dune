-- hooked-party-pass-mint-daily
select
  count(*) as amount,
  date_trunc('day', evt_block_time) as day
from
  hookedprotocal_bnb.HPPNFT_evt_Transfer
where
  `from` = '0x0000000000000000000000000000000000000000'
group by
  date_trunc('day', evt_block_time)