with all_data as (select
ad_date
, 'Facebook Ads' as media_source
, campaign_name
, adset_name
, spend, impressions, reach, clicks, leads, value
from facebook_ads_basic_daily fabd
left join facebook_campaign fc on fc.campaign_id = fabd.campaign_id
left join facebook_adset using (adset_id)
union all
select
ad_date
, 'Google Ads' as media_source
, campaign_name
, adset_name
, spend, impressions, reach, clicks, leads, value
from google_ads_basic_daily)
select
ad_date
, media_source
, campaign_name
, adset_name
, sum(spend) as total_spend
, sum(impressions) as total_impressions
, sum(clicks) as total_clicks
, sum(value) as total_value
from all_data
group by ad_date
, media_source
, campaign_name
, adset_name
