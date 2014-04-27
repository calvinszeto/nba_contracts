from scrapy.contrib.spiders import CrawlSpider, Rule
from scrapy.contrib.linkextractors.sgml import SgmlLinkExtractor
from scrapy.selector import Selector

from salary_scraper.items import Salary

class SalarySpider(CrawlSpider):
    name = "salary"
    allowed_domains = ["basketball-reference.com"]
    start_urls = [
        "http://www.basketball-reference.com/players/"
    ]

    rules = [
        # From players page, navigate to each letter
        Rule(SgmlLinkExtractor(allow=r'players\/[a-z]\/$')),
        # From a letter, navigate to each player and parse
        Rule(SgmlLinkExtractor(allow=r'players\/[a-z]\/.+\.html$')
            , callback='parse_player')
    ]

    def parse_player(self, response):
        sel = Selector(response)
        player = sel.xpath("//h1/text()").extract()[0]
        # Check that salary data exists
        salary_tab = sel.xpath("//table[@id='salaries']")
        if salary_tab:
            for salary_row in salary_tab.xpath('tbody/tr'): 
                league = salary_row.xpath('td/a/text()')[1].extract()
                if league == 'NBA':
                    salary = Salary()
                    salary['player'] = player
                    salary['team'] = (salary_row.xpath('td/a/text()')[0]
                        .extract())
                    salary['season'] = (salary_row.xpath('td/text()')[0]
                        .extract())
                    salary['amount'] = (salary_row.xpath('td/text()')[1]
                        .extract())
                    yield salary
