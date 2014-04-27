# Scrapy settings for salary_scraper project
#
# For simplicity, this file contains only the most important settings by
# default. All the other settings are documented here:
#
#     http://doc.scrapy.org/en/latest/topics/settings.html
#

BOT_NAME = 'salary_scraper'

SPIDER_MODULES = ['salary_scraper.spiders']
NEWSPIDER_MODULE = 'salary_scraper.spiders'

DOWNLOAD_DELAY = 0.5

# Crawl responsibly by identifying yourself (and your website) on the user-agent
#USER_AGENT = 'salary_scraper (+http://www.yourdomain.com)'
