-- airdrop-sender-filter
with
  addresses as (
    select distinct
      `to` as address
    from
      hookedprotocal_bnb.HPPNFT_evt_Transfer
  ),
  senders as (
    select
      count(tr.`from`) as num,
      tr.`from`
    from
      hookedprotocal_bnb.HookToken_evt_Transfer tr,
      addresses
    where
      tr.to = addresses.address
      and tr.evt_block_time > '2022-12-15'
      and tr.evt_block_time < '2022-12-16'
    group by
      tr.`from`
  )
select
  *
from
  senders
where
  num > 10;