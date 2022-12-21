-- hooked-party-pass-holder-amount
select
  count(distinct tokenId) as holder_amount
from
  hookedprotocal_bnb.HPPNFT_evt_Transfer