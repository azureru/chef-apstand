appsindo CHANGELOG
==================

1.2.0
-----
-- Finalize the nginx for pagespeed
-- Tweak some of the nginx default properties
-- Add vagrant user to base www-data group (need to check for vagrant based user for better development flow)
-- Add pool file for fpm
-- Add hhvm recipee
-- Fix issue with nginx recipee when installed from already provisioned state

1.1.0
-----
- Convert logrotate, upstart, nginx to LWRP
- Fix nginx issues with upstart

1.0
---
- Make sure it's all BSD
- Force password - do not use default one

0.1.0
-----
- [azureru] - Initial release of appsindo standard recipe

